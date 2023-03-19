import java.util.Random;
import java.util.HashMap;

public static final int MIN_WIDTH = 300;
public static final int MIN_HEIGHT = 300;
public static final int MARGIN = 50;
public static final int MAX_ROOM_WIDTH = MIN_WIDTH - 2 * MARGIN ;
public static final int MAX_ROOM_HEIGHT = MIN_HEIGHT - 2 * MARGIN;
public static final int HALFCOR = 20;
public static final int INCREMENT_PROPORTION = 300;
public static final int ROAM_INCREMENT_PROPORTION = 1000;
public static final int CHASE_INCREMENT_PROPORTION = 500;
public static final int ALERT_DISTANCE = 100;

BSPnode root;
PVector portal;

ArrayList<Room> roomList;
ArrayList<Corridor> corList;
ArrayList<Door> doorList;
ArrayList<Enemy> enemyList;
ArrayList<Item> itemList;
HashMap<Integer, ArrayList<BSPnode>> nodes;

Character human;

boolean moveLeft = false;
boolean moveRight = false;
boolean moveUp = false;
boolean moveDown = false;




void setup(){
  fullScreen() ;  
  int chaIncrement = displayWidth/INCREMENT_PROPORTION ; 
  int roamIncrement = displayWidth/ROAM_INCREMENT_PROPORTION ; 
  int chaseIncrement = displayWidth/CHASE_INCREMENT_PROPORTION ; 
    
  roomList = new ArrayList<Room>();
  corList = new ArrayList<Corridor>();
  doorList =  new ArrayList<Door>();
  enemyList = new ArrayList<Enemy>();
  itemList = new ArrayList<Item>();
  
  root = new BSPnode(new point(0,0), displayWidth, displayHeight, null, -1);
  nodes = new HashMap<Integer, ArrayList<BSPnode>>();
  generate(root);
  
  Integer zero = 0;
  ArrayList<BSPnode> origin =  new ArrayList<BSPnode>();
  origin.add(root);
  nodes.put(zero,origin);
  
  nodes.forEach((key, value) -> {
      for(BSPnode temp : value){
        //System.out.println(key + " / " + temp.depth + ": " + temp.topLeft.x + " " + temp.topLeft.y);
        if(temp.leftChild == null && temp.rightChild == null){
          temp.generateRoom();
          temp.createKeyPoint();
        }
      }
  });
  root.creatPathBetweenChildren();
  createPathBetweenInnodes();
  
  //generate human
  human = new Character(chaIncrement);
  
  //generate portal
  Room portalRoom = roomList.get(new Random().nextInt(0, roomList.size()));
  portal = new PVector(portalRoom.mynode.keyPoint.x, portalRoom.mynode.keyPoint.y);
  
  //generate enemy & items
  for(Room r : roomList){
    if(r != human.atRoom){
      int enemyNum = new Random().nextInt(1,3);
      for(int i=0;i<enemyNum;i++){
        Enemy temp = new Enemy(roamIncrement,chaseIncrement,r);
        enemyList.add(temp);
      }
      Item item;
      int itemType = new Random().nextInt(0,2);
      if(itemType == 0){
         item = new Item("medicine", r);
      }else{
         item = new Item("potion", r);
      }
      itemList.add(item);
    }
  }

    //generate key
    Item Key = new Item("key", farthestRoom());
    itemList.add(Key);

  
}

void draw(){
  background(#050505) ;
  for(Room r: roomList){
    r.draw();
  }
  stroke(#CBC9C9);
 //nodes.forEach((key, value) -> {
 //     for(BSPnode temp : value){
 //       //System.out.println(key + " / " + temp.depth + ": " + temp.topLeft.x + " " + temp.topLeft.y);
 //       if(temp.keyPoint != null){
 //            fill(#C64040);
 //             rect(temp.keyPoint.x,temp.keyPoint.y,10,10);
 //       }
 //     }
 // });
  for(Corridor c: corList){
    c.draw();
  }
  for(Door d:doorList){
    d.draw();
  }
  
  for(Enemy e:enemyList){
    float dis = calculate2PointDis(human.position.x, human.position.y, e.position.x, e.position.y);
    if(dis < ALERT_DISTANCE){
      e.status = "chasing";
    }
    e.move();
    e.draw();
  }
  
  for(Item i:itemList){
    i.draw();
  }
  
  //draw portal
  fill(#4C4598);
  rect(portal.x, portal.y, 50,70);
  
  if(moveRight){
    human.move("right");
  }else if(moveLeft){
    human.move("left");
  }else if(moveUp){
    human.move("up");
  }else if(moveDown){
    human.move("down");
  }
  human.draw();
  

  
}

void keyPressed(){
  if(key == CODED){
    switch(keyCode){
      case LEFT :
        moveLeft = true;
        break;
      case RIGHT :
        moveRight = true;
        break;
      case UP :
        moveUp = true;
        break;
      case DOWN :
        moveDown = true;
        break;
    }
  }
}

void keyReleased(){
    switch(keyCode){
      case LEFT :
        moveLeft = false;
        break;
      case RIGHT :
        moveRight = false;
        break;
      case UP :
        moveUp = false;
        break;
      case DOWN :
        moveDown = false;
        break;
    }
}

void generate(BSPnode current){
    if(current.isDividable()){
      current.divide();
      
      int nextDepth = current.depth + 1;
      if(!nodes.containsKey(nextDepth)){
        nodes.put(nextDepth, new ArrayList<BSPnode>());
      }
      nodes.get(nextDepth).add(current.leftChild);
      nodes.get(nextDepth).add(current.rightChild);
      
      generate(current.leftChild);
      generate(current.rightChild);
    }
    return;
}


public void createPathBetweenInnodes(){
    int treeDepth = -1;
    for(int key: nodes.keySet()) {
      if(key > treeDepth)
        treeDepth = key;
    }

    //System.out.println("treeDepth: "+treeDepth);


    // find inner nodes and gather their sub keypoints.
    for(int i = treeDepth; i>=0;i--){
      ArrayList<BSPnode> templist = nodes.get(i);
      for(BSPnode t : templist){
        if(t.leftChild != null || t.rightChild != null){
            if(t.leftChild !=null){
              t.keyPoints.addAll(t.leftChild.keyPoints);
            }
            if(t.rightChild !=null){
              t.keyPoints.addAll(t.rightChild.keyPoints);
            }
             //System.out.println("inner node: " + t.depth + " keyPoints num: " + t.keyPoints.size());         
        }
      }
    }
    
    //connect inner nodes with their siblings
    for(int i = treeDepth; i>=1; i--){
       ArrayList<BSPnode> templist = nodes.get(i);
      for(BSPnode t : templist){
        if(t.leftChild != null || t.rightChild != null){

          //find a inner node
          BSPnode parrent = t.parrent;
          BSPnode plc = parrent.leftChild;
          BSPnode prc = parrent.rightChild;
          
          //create the path
          if(parrent.path == null){
              parrent.path = new ArrayList<point>();
              
              if(parrent.direction == 0){ //cut horizontal
                int middle_y = parrent.topLeft.y + parrent.split;
                point leftKP = new point(0,0);
                point rightKP = new point(0,0);
                int distance = 50000;
                for(point p : plc.keyPoints){
                   if(Math.abs(p.y - middle_y) < distance){
                     distance = Math.abs(p.y - middle_y);
                     leftKP = p;
                   }
                }

                distance = 50000;
                for(point p : prc.keyPoints){
                   if(Math.abs(p.y - middle_y) < distance){
                     distance = Math.abs(p.y - middle_y);
                     rightKP = p;
                   }
                }
                    //parrent.path.add(leftKP);
                    //parrent.path.add(rightKP);
                    point center = new point((leftKP.x+rightKP.x)/2, (leftKP.y+rightKP.y)/2 );
                    point left = new point(leftKP.x, center.y);
                    point right = new point(rightKP.x,center.y);
                    point leftEnd;
                    point rightEnd;
                    if(leftKP.y>rightKP.y){
                      leftEnd = new point(leftKP.x, leftKP.y - getHbyP(leftKP)/2);
                      rightEnd = new point(rightKP.x, rightKP.y + getHbyP(rightKP)/2);
                    }else{
                      leftEnd = new point(leftKP.x, leftKP.y +  getHbyP(leftKP)/2); 
                      rightEnd = new point(rightKP.x, rightKP.y - getHbyP(rightKP)/2);
                    }
                    parrent.path.add(center);parrent.path.add(left);parrent.path.add(right);parrent.path.add(leftEnd);parrent.path.add(rightEnd);

                    Door d1 = new Door(new point(leftEnd.x - HALFCOR, leftEnd.y), new point(leftEnd.x + HALFCOR, leftEnd.y));
                    Door d2 = new Door(new point(rightEnd.x - HALFCOR, rightEnd.y), new point(rightEnd.x + HALFCOR, rightEnd.y));
                    int midWidth = Math.abs(left.x - right.x) - 2*HALFCOR;
                    Door d3 = new Door(new point(center.x - midWidth/2, center.y - HALFCOR), new point(center.x - midWidth/2, center.y + HALFCOR));
                    Door d4 = new Door(new point(center.x + midWidth/2, center.y - HALFCOR), new point(center.x + midWidth/2, center.y + HALFCOR));
      
                    doorList.add(d1);doorList.add(d2);doorList.add(d3);doorList.add(d4);

              }else{ // cut vertical
              
                int middle_x = parrent.topLeft.x + parrent.split;
                point leftKP = new point(0,0);
                point rightKP = new point(0,0);
                int distance = 50000;
                for(point p : plc.keyPoints){
                   if(Math.abs(p.x - middle_x) < distance){
                     distance = Math.abs(p.x - middle_x);
                     leftKP = p;
                   }
                }

                distance = 50000;
                for(point p : prc.keyPoints){
                   if(Math.abs(p.x - middle_x) < distance){
                     distance = Math.abs(p.x - middle_x);
                     rightKP = p;
                   }
                }
                    //parrent.path.add(leftKP);
                    //parrent.path.add(rightKP);
                
                    point center = new point((leftKP.x+rightKP.x)/2, (leftKP.y+rightKP.y)/2 );
                    point left = new point(center.x, leftKP.y);
                    point right = new point(center.x, rightKP.y);
                    point leftEnd;
                    point rightEnd;
                    if(leftKP.x<rightKP.x){
                      leftEnd = new point(leftKP.x + getWbyP(leftKP)/2,leftKP.y);
                      rightEnd = new point(rightKP.x - getWbyP(rightKP)/2, rightKP.y);
                    }else{
                      leftEnd = new point(leftKP.x - getWbyP(leftKP)/2,leftKP.y); 
                      rightEnd = new point(rightKP.x + getWbyP(rightKP)/2, rightKP.y);
                    }
                    parrent.path.add(center);parrent.path.add(left);parrent.path.add(right);parrent.path.add(leftEnd);parrent.path.add(rightEnd);
                
                    Door d1 = new Door(new point(leftEnd.x, leftEnd.y - HALFCOR), new point(leftEnd.x, leftEnd.y + HALFCOR));
                    Door d2 = new Door(new point(rightEnd.x, rightEnd.y - HALFCOR), new point(rightEnd.x, rightEnd.y + HALFCOR));
                    int midWidth = Math.abs(left.y - right.y) - 2*HALFCOR;
                    Door d3 = new Door(new point(center.x - HALFCOR, center.y - midWidth/2), new point(center.x + HALFCOR, center.y - midWidth/2));
                    Door d4 = new Door(new point(center.x - HALFCOR, center.y + midWidth/2), new point(center.x + HALFCOR, center.y + midWidth/2));
                    
                    doorList.add(d1);doorList.add(d2);doorList.add(d3);doorList.add(d4);
                
              }


              //add path to corridor list
              Corridor c = new Corridor(parrent.path);
              corList.add(c);
          }
          
        }
      }
    }
  }
  
  
  
int getWbyP(point keyPoint){
  for(Room r : roomList){
    point rp = r.mynode.keyPoint;
      if(rp.x == keyPoint.x && rp.y == keyPoint.y){
        return r.roomWidth;
      }
  }
  return 0;
}
int getHbyP(point keyPoint){
  for(Room r : roomList){
    point rp = r.mynode.keyPoint;
      if(rp.x == keyPoint.x && rp.y == keyPoint.y){
        return r.roomHeight;
      }
  }
  return 0;
}

float calculate2PointDis(float x1, float y1, float x2, float y2){
  float distance;
  float w = abs(x1 - x2);
  float h = abs(y1 - y2);
  distance = sqrt(w*w + h*h);
  return distance;
}

float calculate2RoomDis(Room r1, Room r2){
  point p1 = r1.topLeft;
  point p2 = r2.topLeft;
  float dis = calculate2PointDis(p1.x,p1.y,p2.x,p2.y);
  return dis;
}

Room farthestRoom(){
  Room temp = human.atRoom;
  float maxDis = 0;
  float tempDis;
  for(Room r: roomList){
    tempDis = calculate2RoomDis(human.atRoom, r);
    if(tempDis > maxDis){
      maxDis = tempDis;
      temp = r;
    }
  }
  return temp;
}

void newLevel(){


}
