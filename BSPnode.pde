import java.util.Random;


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

  }
  
  void divide(){
      Random random = new Random();
      int small = Math.min(MIN_SIZE,cutsize);
      int large = Math.max(MIN_SIZE,cutsize);
      
      int split = random.nextInt(small,large);
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
        Random random = new Random();
        int x1 = topLeft.x + MARGIN;
        int x2 = topLeft.x + spaceWidth - MARGIN;
        int y1 = topLeft.y + MARGIN;
        int y2 = topLeft.y + spaceHeight - MARGIN;
        
        System.out.println(x1 + " " + x2 + " " + y1 +" " + y2);
        
        int x3 = random.nextInt(x1-1,x2 - MIN_ROOM_SIZE+1);
        int x4 = random.nextInt(x3-1 + MIN_ROOM_SIZE, x2+1);
        
        int y3 = random.nextInt(y1-1,y2 - MIN_ROOM_SIZE+1);
        int y4 = random.nextInt(y3-1 + MIN_ROOM_SIZE, y2+1);
        
        Room r = new Room(x3,y3,x4,y4);
        roomList.add(r);
  
  }
  

}
