final class Item{
  String type; //key, medicine, potion
  int status = 1; //1 = still there, 0 = collected
  Room atRoom;
  PVector position;
  
  Item(String type, Room r){
   this.type = type;
   this.atRoom = r;
   position = randomPosition(r).copy();
  }
  
    PVector randomPosition(Room r){
    PVector p = new PVector();
    Random random = new Random();
    p.x = random.nextInt(r.topLeft.x+1, r.bottomRight.x-1);
    p.y = random.nextInt(r.topLeft.y+1, r.bottomRight.y-1);
    return p;
  }
  
  void draw(){
 
    
    if(status == 1){
      if(type == "key"){
        fill(#FF9717);
        circle(position.x, position.y, 20);
      }else if(type == "medicine"){
        fill(#68DE2F);
        rect(position.x, position.y, 20,20);
      }else if(type == "potion"){
        fill(#312FDE);
        rect(position.x, position.y, 20,20);
      }
    }
    
    if( calculate2PointDis(human.position.x, human.position.y, this.position.x, this.position.y )< 30){
      status = 0;
    }

  }


}
