import java.util.Random;
public static final int MIN_SIZE = 200;
public static final int MARGIN = 5;

final class BSPnode{
  point topLeft;
  
  int spaceWidth;
  int spaceHeight;
  
  BSPnode parent;
  
  BSPnode leftChild;
  BSPnode rightChild;
  Room room;

  int depth;
  int cutsize;
  int direction = -1;
  
  BSPnode(point p,int w, int h, BSPnode parent, int parentDepth){
    topLeft = p;
    this.spaceWidth = w;
    this.spaceHeight = h;
    
    this.parent = parent;
    leftChild = null;
    rightChild = null;
    room = null;
    
    depth = parentDepth+1;
    
    

  }
  
  
  boolean isDividable(){
    if(spaceWidth < spaceHeight) {
      direction = 0 ; //cut the height, horizontal cut
    }else if(spaceWidth >= spaceHeight) {
      direction = 1; // cut the width, vertical cut
    }
    
    if (direction == 0){
      cutsize = spaceHeight - MIN_SIZE;
    }else{
      cutsize = spaceWidth - MIN_SIZE;
    }
    if(cutsize < MIN_SIZE){
      return false;
    }else{
      return true;
    }

    //int split = random.nextInt(MIN_SIZE, cutsize);
    ////nextInt(max)%(max-min+1) + min
    
    //if(direction == 0){
    //  leftChild = new BSPnode(topLeft, spaceWidth, split, this, this.depth);
    //  rightChild = new BSPnode(new point(topLeft.x, topLeft.y + split),
    //      spaceWidth, spaceHeight -split, this, this.depth);
    //}else if(direction == 1){
    //  leftChild = new BSPnode(topLeft, split, spaceHeight, this, this.depth);
    //  rightChild = new BSPnode(new point(topLeft.x + split, topLeft.y),
    //      spaceWidth - split, spaceHeight, this, this.depth);
    //}

  }
  
  void divide(){
      Random random = new Random();
      int split = random.nextInt(MIN_SIZE, cutsize);
      //nextInt(max)%(max-min+1) + min
      if(direction == 0){
        leftChild = new BSPnode(topLeft, spaceWidth, split, this, this.depth);
        rightChild = new BSPnode(new point(topLeft.x, topLeft.y + split),
            spaceWidth, spaceHeight -split, this, this.depth);
      }else if(direction == 1){
        leftChild = new BSPnode(topLeft, split, spaceHeight, this, this.depth);
        rightChild = new BSPnode(new point(topLeft.x + split, topLeft.y),
            spaceWidth - split, spaceHeight, this, this.depth);
      }
  }
  
  void generateRoom(){
        Room r = new Room(topLeft.x,topLeft.y,topLeft.x+10,topLeft.y+10);
        roomList.add(r);
  
  }
  

}
