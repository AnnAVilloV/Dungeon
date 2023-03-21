final class Character{

  String status = "normal"; //normal,fight,dead
  PVector position;
  int moveIncrement ;
  Room atRoom ;
  
  int level = 1;
  int EXPlimit = 100;
  int EXP = 35;
  
  int strength = 5; 
  int agility = 5; 
  
  float HPlimit = 100;
  float armorLimit = 50;
  float HP = HPlimit;
  float armorValue = armorLimit;
  
  float phyAttack = 70;
  float magicAttack = 5;
  
  int mediNum = 5;
  int potionNum = 3;
  
  
  Character(int increment){
    this.moveIncrement = increment;
  }
  
  
 void levelUp(){
      human.level ++;
      human.EXP = human.EXP - 100;
      
      phyAttack += 10;
      magicAttack += 5;
      HPlimit += 10;
      HP = HPlimit;
      armorLimit += 5;
      armorValue = armorLimit;
      strength += 5;
      agility += 5;
  
  } 
  
  void draw(){
    //character value boxes
    fill(255);
    textSize(displayWidth/100);
    text("HP: ",35,40);
    text("Armor: ",15,90);
    
    text(HP + "/" + HPlimit, 280, 40);
    text((int)armorValue + "/" + (int)armorLimit, 280,90);
    
    image(mediImage,400,20,30,30);
    image(potionImage,400,70,30,30);
    text(human.mediNum, 440,40);
    text(human.potionNum, 440,90);
    
    
    //HP
    fill(#9782A5);
    rect(75,25,200,25);
    fill(#4BD331);
    rect(75,25,200*HP/HPlimit,25);

    //armorValue
    fill(#9782A5);
    rect(75,70,200,25);
    fill(#4B00FF);
    rect(75,70,200*armorValue/armorLimit,25);
    
    //EXP
    fill(#9782A5);
    rect(displayWidth/2 - displayWidth/8, displayHeight/40, displayWidth/4, displayHeight/40);
    fill(#F0D135);
    rect(displayWidth/2 - displayWidth/8, displayHeight/40, displayWidth/4 * EXP/EXPlimit, displayHeight/40);
    fill(0);
    text(EXP + "/" + EXPlimit, displayWidth/2-displayWidth/80, displayHeight*7/160);
    fill(255);
    text("EXP:",displayWidth/2 - displayWidth*5/32,displayHeight*7/160 );
    text("Lv: " + level, displayWidth*5/8 + displayWidth/64,displayHeight*7/160 );

    //the character
    fill(#082DFA);
    circle(position.x,position.y, 30);
  

  
      if(Key.status == 0){
      if(calculate2PointDis(position.x, position.y,portal.x,portal.y) < 60)
        newLevel();
    }
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
