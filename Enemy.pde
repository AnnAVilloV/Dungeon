final float MINDIS = 0.1f;
//final float MAX_SPEED = 3f ;
final float ORIENTATION_INCREMENT = PI/32 ;

final class Enemy{
  PVector position = new PVector(0,0);
  String status = "roaming"; //roaming, chasing, dead
  Room atRoom;
  
  int roamIncrement ;
  int chaseIncrement ;
  
  float orientation = 0f;
  PVector velocity = new PVector(0.1f,0.1f);
  PVector aim;
  
  Enemy(int roamInc, int chaseInc, Room r){
    this.roamIncrement = roamInc;
    this.chaseIncrement = chaseInc;
    this.atRoom = r;
    this.position = randomPosition(r).copy();
    this.aim = randomPosition(r).copy();
  }
  
  void draw(){
    fill(#BF112B);
    circle(position.x,position.y, 35);
    int x = (int)(position.x + 10 * cos(orientation));  
    int y = (int)(position.y + 10 * sin(orientation));
    fill(0);
    circle(x,y,10);
        
  }
  
  
  PVector randomPosition(Room r){
    PVector p = new PVector();
    Random random = new Random();
    p.x = random.nextInt(r.topLeft.x+1, r.bottomRight.x-1);
    p.y = random.nextInt(r.topLeft.y+1, r.bottomRight.y-1);
    return p;
  }
  
  void move(){
    if(status == "roaming"){
      roam();
    }else if(status == "chasing"){
       chase();
    }
  }
  
  void roam(){
      if(position.x == aim.x && position.y == aim.y){
        aim = randomPosition(atRoom).copy();
      }
      PVector toTarget = new PVector(aim.x - position.x, aim.y - position.y);
      this.integrate(toTarget);
  }  
  
  void chase(){
    if(human.atRoom == this.atRoom){
      PVector toTarget = new PVector(human.position.x - position.x, human.position.y - position.y);
      this.integrate(toTarget);
    }else{
      status = "roaming";
    }
  }
  
void integrate(PVector toTarget){
    float distance = toTarget.mag();
          
    velocity = toTarget.copy();
    
    if(status == "roaming"){
      if(distance > roamIncrement){
      //调整速度
      velocity = velocity.normalize().mult(roamIncrement);
      }
    }else if(status == "chasing"){
      if(distance > chaseIncrement){
      //调整速度
      velocity = velocity.normalize().mult(chaseIncrement);
      }
    }

    
    position.add(velocity);
    
    
    //接下来是get朝向
    float targetOri = atan2(velocity.y, velocity.x);
    
    //这一小块不知道是干啥的
    if(abs(targetOri - orientation) <= ORIENTATION_INCREMENT){
      orientation = targetOri;
      return;
    }
    
    //这块调整朝向
    if(targetOri < orientation){
      if(orientation - targetOri < PI){
        orientation -= ORIENTATION_INCREMENT ;
      }else{
        orientation += ORIENTATION_INCREMENT ;
      }
    }else{
      if(orientation - targetOri < PI){
        orientation += ORIENTATION_INCREMENT ;
      }else{
        orientation -= ORIENTATION_INCREMENT ;
      }
    }
    
    //让它不要疯狂旋转
     if (orientation > PI) 
       orientation -= 2*PI ;
     else if (orientation < -PI) 
       orientation += 2*PI ;  
        
  }
  
  

}
