import java.util.Random;
import java.util.HashMap;

public static final int MIN_WIDTH = 300;
public static final int MIN_HEIGHT = 300;
public static final int MARGIN = 20;
public static final int MAX_ROOM_WIDTH = MIN_WIDTH - 2 * MARGIN ;
public static final int MAX_ROOM_HEIGHT = MIN_HEIGHT - 2 * MARGIN;
//public static final int MIN_WIDTH = 0;

BSPnode root;
ArrayList<Room> roomList;
HashMap<Integer, ArrayList<BSPnode>> nodes;

void setup(){
  fullScreen() ;  
  roomList = new ArrayList<Room>();
  root = new BSPnode(new point(0,0), displayWidth, displayHeight, null, -1);
  nodes = new HashMap<Integer, ArrayList<BSPnode>>();
  generate(root);
  nodes.forEach((key, value) -> {
      for(BSPnode temp : value){
        //System.out.println(key + " / " + temp.depth + ": " + temp.topLeft.x + " " + temp.topLeft.y);
        if(temp.leftChild == null && temp.rightChild == null){
          temp.generateRoom();
        }
      }
  });
}

void draw(){
  background(#050505) ;
  for(Room r: roomList){
    r.draw();
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
