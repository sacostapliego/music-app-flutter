
import uuid
import bcrypt
import jwt

from fastapi import Depends, HTTPException, Header
from database import get_db
from middleware.auth_middleware import auth_middleware
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session
from pydantic_schemas.user_login import UserLogin

router = APIRouter()

@router.post('/signup', status_code=201)
def signup_user(user: UserCreate, db:Session=Depends(get_db)):
    # check if the user already exists in the db
    user_db = db.query(User).filter(User.email == user.email).first() 

    if user_db:
        raise HTTPException(400,'User with the same email already exists')
    
    #hash password
    hawshed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())

    user_db = User(
        id = str (uuid.uuid4()),
        email = user.email,
        password = hawshed_pw,
        name = user.name
    ) # git init

    # add the user to the db

    db.add(user_db) # git add
    db.commit() # git commit
    db.refresh(user_db) 

    return user_db

@router.post('/login')
def login_user(user: UserLogin, db:Session=Depends(get_db)):
    # check if the user with same email already exists
    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db:
        raise HTTPException(404, 'User with this email does not exist') # user does not exist

    # password matching or not
    is_match = bcrypt.checkpw(user.password.encode(), user_db.password)

    # if the user exists, return the user data
    if not is_match:
        raise HTTPException(400, 'Invalid password') # password does not match

    #TODO: process.env later
    token = jwt.encode({'id': user_db.id}, 'password_key')
    
    return {'token': token, 'user': user_db}

@router.get('/')
def current_user_data(db: Session=Depends(get_db), user_dict = Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uid']).first()

    if not user:
        raise HTTPException(404, 'User not found')
    
    return user