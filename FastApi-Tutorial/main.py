from fastapi import FastAPI

app = FastAPI()


#Creating a list of items 

items =[]



@app.get("/")
def root():
    return{"Hello": "There"}



@app.post("/ items")
def create_item(item: str):
    items.append(item)
    return items   