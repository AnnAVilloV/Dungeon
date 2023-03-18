final class Character{

  point position;
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
    position = this.atRoom.mynode.keyPoint;
  }
  
 void move(String direction){
    if(direction == "left"){
      position.x -= moveIncrement ;  
    }else if(direction == "right"){
      position.x += moveIncrement ;  
    }else if(direction == "up"){
      position.y -= moveIncrement ;  
    }else if(direction == "down"){
      position.y += moveIncrement ;  
    }
 }
  
 void hit(){
   
 }
 void inWhichSpace(){
    
  
 }
 boolean inTheRoom(){
   if(position.x > atRoom.topLeft.x && position.x < atRoom.bottomRight.x  ){
   
   }
   return true;
 }

}
