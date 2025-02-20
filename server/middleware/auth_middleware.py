from fastapi import HTTPException, Header
import jwt

def auth_middleware(x_auth_token = Header()):
    try:
            # get user token from the headers
            if not x_auth_token:
                raise HTTPException(401, 'No auth token, access denied.')

            # decode the token
            
            #TODO: process.env later
            verified_token = jwt.decode(x_auth_token, 'password_key', algorithms=['HS256'])

            if not verified_token:
                raise HTTPException(401, 'Token verification failed, access denied')
            
            # get the id from the token
            uid = verified_token.get('id')
            return {'uid': uid, 'token': x_auth_token}

            # contact the postgres db to get the user data
    except jwt.PyJWTError:
            raise HTTPException(401, 'Token verification failed, access denied')