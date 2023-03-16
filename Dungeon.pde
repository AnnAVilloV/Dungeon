import java.util.Random;
import java.util.HashMap;

public static final int MIN_WIDTH = 300;
public static final int MIN_HEIGHT = 300;
public static final int MARGIN = 50;
public static final int MAX_ROOM_WIDTH = MIN_WIDTH - 2 * MARGIN ;
public static final int MAX_ROOM_HEIGHT = MIN_HEIGHT - 2 * MARGIN;

public static final int HALFCOR = 15;
//public static final int MIN_WIDTH = 0;

BSPnode root;

ArrayList<Room> roomList;
ArrayList<Corridor> corList;
HashMap<Integer, ArrayList<BSPnode>> nodes;

void setup(){
  fullScreen() ;  
  roomList = new ArrayList<Room>();
  corList = new ArrayList<Corridor>();
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
  
}

void draw(){
  background(#050505) ;
  for(Room r: roomList){
    r.draw();
  }
  
 nodes.forEach((key, value) -> {
      for(BSPnode temp : value){
        //System.out.println(key + " / " + temp.depth + ": " + temp.topLeft.x + " " + temp.topLeft.y);
        if(temp.keyPoint != null){
             fill(#C64040);
              rect(temp.keyPoint.x,temp.keyPoint.y,10,10);
        }
        
      }
  });
  
  for(Corridor c: corList){
    c.draw();
    
  }

  
  fill(255);
  text("normal",100,100);
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
