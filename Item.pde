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
    p.x = random.nextInt(r.topLeft.x+20, r.bottomRight.x-20);
    p.y = random.nextInt(r.topLeft.y+20, r.bottomRight.y-20);
    return p;
  }
  
  void draw(){
 
    
    if(status == 1){
      if(type == "key"){
        image(keyImage,position.x,position.y,30,30);
        //fill(#FF9717);
        //circle(position.x, position.y, 20);
      }else if(type == "medicine"){
        image(mediImage,position.x,position.y,40,40);
      }else if(type == "potion"){
        image(potionImage,position.x,position.y,40,40);
      }
      
      if( calculate2PointDis(human.position.x, human.position.y, this.position.x, this.position.y )< 40){
          if(type == "medicine"){
             human.mediNum += 1;
             status = 0;
          }else if(type == "potion"){
            human.potionNum += 1;
            status = 0;
          }else if(type == "key"){
            Key.status = 0;
          }
       }
    

      
    }

  }


}
