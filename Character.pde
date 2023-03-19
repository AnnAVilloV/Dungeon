final class Character{

  PVector position;
  int moveIncrement ;
  Room atRoom ;
  
  Character(int increment){
    this.moveIncrement = increment;
    setStartSpace();
  }
  
  void draw(){
    
    fill(#082DFA);
    circle(position.x,position.y, 30);
  
  
  }
   
  void setStartSpace(){
    int roomNum = roomList.size();
    this.atRoom = roomList.get(new Random().nextInt(0,roomNum));
    position = new PVector(this.atRoom.mynode.keyPoint.x, this.atRoom.mynode.keyPoint.y);
  }
  
 void move(String direction){
    if(direction == "left"){
      position.x -= moveIncrement ;  
      if(hit()){
        position.x = atRoom.topLeft.x+1;
      }
    }else if(direction == "right"){
      position.x += moveIncrement ;  
      if(hit()){
        position.x = atRoom.bottomRight.x-1;
      }
    }else if(direction == "up"){
      position.y -= moveIncrement ;  
      if(hit()){
        position.y = atRoom.topLeft.y+1;
      }
    }else if(direction == "down"){
      position.y += moveIncrement ;  
      if(hit()){
        position.y = atRoom.bottomRight.y-1;
      }
    }
    

 }
  
 boolean hit(){
   if(!this.inTheRoom(this.atRoom)){
     if(this.inWhichSpace() == null){
       return true;
     }
   }
   return false;
 }
 Room inWhichSpace(){
    for(Room r:roomList){
       if(this.inTheRoom(r)){
         if(r != this.atRoom)
           this.atRoom = r;
         return r;
       }
    }
    for(Corridor c : corList){
      for(Room r : c.rooms){
         if(this.inTheRoom(r)){
           if(r != this.atRoom)
             this.atRoom = r;
           return r;
         }
      }
    }
   return null;
 }
 boolean inTheRoom(Room r){
   if(position.x > r.topLeft.x && position.x < r.bottomRight.x && position.y > r.topLeft.y && position.y < r.bottomRight.y ){
     return true;
   }
   return false;
 }

}
