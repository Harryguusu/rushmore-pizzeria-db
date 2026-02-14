import psycopg2
import os

DB_HOST = "localhost"
DB_NAME = "rushmore_db"
DB_USER = "HARRY_GUUSU"
DB_PASSWORD = ""

print("=" * 60)
print("🗑️  RUSHMORE DATABASE RESET TOOL")
print("=" * 60)

try:
    # Connect to database
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    cursor = conn.cursor()
    print("✅ Connected to database")

    # Disable triggers
    cursor.execute("SET session_replication_role = 'replica';")
    
    # List of tables in correct deletion order
    tables = [
        "order_items",
        "recipe",
        "inventory",
        "\"order\"",
        "customer",
        "menu_items",
        "ingredients",
        "stores"
    ]
    
    # Truncate all tables
    for table in tables:
        try:
            cursor.execute(f"TRUNCATE TABLE {table} CASCADE;")
            print(f"  ✓ Cleared: {table}")
        except Exception as e:
            print(f"  ⚠️ Skipped {table}: {e}")
    
    # Reset all sequences
    cursor.execute("""
        SELECT 'SELECT SETVAL(' ||
               quote_literal(quote_ident(PGT.schemaname) || '.' || quote_ident(S.relname)) ||
               ', 1, false) FROM ' ||
               quote_ident(PGT.schemaname)|| '.'||quote_ident(T.relname)|| ';'
        FROM pg_class AS S,
             pg_depend AS D,
             pg_class AS T,
             pg_attribute AS C,
             pg_tables AS PGT
        WHERE S.relkind = 'S'
            AND S.oid = D.objid
            AND D.refobjid = T.oid
            AND D.refobjid = C.attrelid
            AND D.refobjsubid = C.attnum
            AND T.relname = PGT.tablename
    """)
    
    for statement in cursor.fetchall():
        try:
            cursor.execute(statement[0])
            print(f"  ✓ Reset sequence")
        except:
            pass
    
    # Re-enable triggers
    cursor.execute("SET session_replication_role = 'origin';")
    
    conn.commit()
    print("\n✅ DATABASE COMPLETELY CLEANED!")
    print("=" * 60)

except Exception as e:
    print(f"\n❌ Error: {e}")

finally:
    if 'conn' in locals():
        cursor.close()
        conn.close()
        print("🔌 Connection closed.")