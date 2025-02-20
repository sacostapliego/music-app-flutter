from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql://postgres:bluejay@localhost:5432/musicapp"

engine = create_engine(DATABASE_URL) # start the connection to the db
SessionLocal = sessionmaker(autocommit = False, autoflush=False, bind=engine) # create a session

def get_db():
    db = SessionLocal() # create a db session
    try:
        yield db
    finally:
        db.close() # close the session