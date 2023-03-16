import java.util.Random;

final class BSPnode{
  point topLeft;
  
  int spaceWidth;
  int spaceHeight;
  
  BSPnode parrent;
  
  BSPnode leftChild;
  BSPnode rightChild;
  Room room;

  point keyPoint;
  ArrayList<point> path;
  ArrayList<point> keyPoints = new ArrayList<point>();

  int depth;
  int cutsize;
  int direction = -1;
  int split;
  
  BSPnode(point p,int w, int h, BSPnode parent, int parentDepth){
    topLeft = p;
    this.spaceWidth = w;
    this.spaceHeight = h;
    
    this.parrent = parent;
    leftChild = null;
    rightChild = null;
    room = null;
    
    
    depth = parentDepth+1;
    
    

  }
  
  
  boolean isDividable(){
    Random r = new Random();
     direction = r.nextInt(0,2);
    
    if (direction == 0){ //cut horizontal
      cutsize = spaceHeight - MIN_HEIGHT;
        if(cutsize < MIN_HEIGHT ){
          return false;
        }else{
          return true;
        }
    }else{ //cut vertical
      cutsize = spaceWidth - MIN_WIDTH;
        if(cutsize < MIN_WIDTH ){
          return false;
        }else{
          return true;
        }
    }
    
    
    //if(cutsize < MIN_WIDTH ){
    //  return false;
    //}else{
    //  return true;
    //}

  }
  
  void divide(){
      Random random = new Random();
      //int small = Math.min(MIN_WIDTH,cutsize);
      //int large = Math.max(MIN_WIDTH,cutsize); 
      //int split = random.nextInt(small,large);
      //nextInt(max)%(max-min+1) + min
      if(direction == 0){
        int small = Math.min(MIN_HEIGHT,cutsize);
        int large = Math.max(MIN_HEIGHT,cutsize); 
        this.split = random.nextInt(small,large+1);
        leftChild = new BSPnode(topLeft, spaceWidth, split, this, this.depth);
        rightChild = new BSPnode(new point(topLeft.x, topLeft.y + split),
            spaceWidth, spaceHeight -split, this, this.depth);
      }else if(direction == 1){
        int small = Math.min(MIN_WIDTH,cutsize);
        int large = Math.max(MIN_WIDTH,cutsize); 
        this.split = random.nextInt(small,large+1);
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
        
        //System.out.println(x1 + " " + x2 + " " + y1 +" " + y2);
        
        int x3 = random.nextInt(x1-1,x2 - MAX_ROOM_WIDTH+1);
        int x4 = random.nextInt(x3-1 + MAX_ROOM_WIDTH, x2+1);
        
        int y3 = random.nextInt(y1-1,y2 - MAX_ROOM_HEIGHT+1);
        int y4 = random.nextInt(y3-1 + MAX_ROOM_HEIGHT, y2+1);
        
        room = new Room(x3,y3,x4,y4,this);
        roomList.add(room);
  
  }
  
    public void createKeyPoint() {
    if(room != null) {
      int point_x = room.topLeft.x + room.roomWidth/2;
      int point_y = room.topLeft.y + room.roomHeight/2;
      this.keyPoint = new point(point_x, point_y);
      this.keyPoints.add(keyPoint);
       
    }

    return;
  }
  
  public void creatPathBetweenChildren() {
    if(room != null) {
      return;
    }
        //recursive case;
        if( leftChild != null && leftChild.room == null) //left child is an internal node
          leftChild.creatPathBetweenChildren();
        if( rightChild != null && rightChild.room == null) //right child is an internal node
          rightChild.creatPathBetweenChildren();
               
        
        if(leftChild != null && rightChild != null && leftChild.room != null && rightChild.room != null){

          
          //connect rooms
          //1.detect effect edge
          Room r1 = leftChild.room;
          Room r2 = rightChild.room;
          point k1 = leftChild.keyPoint;
          point k2 = rightChild.keyPoint;
          path = new ArrayList<point>();
          
          if(this.direction == 0){
            int effectx1 = Math.max(r1.topLeft.x,r2.topLeft.x);
            int effectx2 = Math.min(r1.topLeft.x + r1.roomWidth, r2.topLeft.x + r2.roomWidth);
            
            if(effectx1 < effectx2){
              //System.out.println("has effect x edge");
              int path_x = (effectx1 + effectx2)/2;
              int path_y1, path_y2;
              if(Math.abs(r2.topLeft.y+r2.roomHeight - r1.topLeft.y) > Math.abs(r1.topLeft.y+r1.roomWidth - r2.topLeft.y)){
                path_y1 = r1.topLeft.y + r1.roomHeight;
                path_y2 = r2.topLeft.y;
              }else{
                path_y1 = r2.topLeft.y + r2.roomHeight;
                path_y2 = r1.topLeft.y;
              }
              path.add(new point(path_x,path_y1));
              path.add(new point(path_x,path_y2));

            }else{
              System.out.println("no effect edge, plan B");
              point center = new point((k1.x+k2.x)/2, (k1.y+k2.y)/2 );
              point left = new point(k1.x, center.y);
              point right = new point(k2.x,center.y);
              point leftEnd;
              point rightEnd;
              if(k1.y>k2.y){
                leftEnd = new point(k1.x, k1.y - r1.roomHeight/2);
                rightEnd = new point(k2.x, k2.y + r2.roomHeight/2);
              }else{
                leftEnd = new point(k1.x, k1.y + r1.roomHeight/2); 
                rightEnd = new point(k2.x, k2.y - r2.roomHeight/2);
              }
              path.add(center);path.add(left);path.add(right);path.add(leftEnd);path.add(rightEnd);
            }
          }else if(this.direction == 1){
              int effecty1 = Math.max(r1.topLeft.y,r2.topLeft.y);
              int effecty2 = Math.min(r1.topLeft.y + r1.roomHeight, r2.topLeft.y + r2.roomHeight);
            
            if(effecty1<effecty2){
               //System.out.println("has effect y edge");
               int path_y = (effecty1 + effecty2)/2;
               int path_x1, path_x2;
                if(Math.abs(r2.topLeft.x+r2.roomWidth - r1.topLeft.x) > Math.abs(r1.topLeft.x+r1.roomHeight - r2.topLeft.x)){
                  path_x1 = r1.topLeft.x + r1.roomWidth;
                  path_x2 = r2.topLeft.x;
                }else{
                  path_x1 = r2.topLeft.x + r2.roomWidth;
                  path_x2 = r1.topLeft.x;
                }
                path.add(new point(path_x1,path_y));
                path.add(new point(path_x2,path_y));
                
            }else{
              System.out.println("no effect edge, plan B");
              point center = new point((k1.x+k2.x)/2, (k1.y+k2.y)/2 );
              point left = new point(k1.y, center.x);
              point right = new point(k2.y,center.x);
              
              point leftEnd;
              point rightEnd;
              if(k1.x < k2.x){
                leftEnd = new point(k1.x + r1.roomWidth/2, k1.y);
                rightEnd = new point(k2.x - r2.roomWidth/2, k2.y);
              }else{
                leftEnd = new point(k1.x - r1.roomWidth/2, k1.y); 
                rightEnd = new point(k2.x + r2.roomWidth/2, k2.y);
              }
              path.add(center);path.add(left);path.add(right);path.add(leftEnd);path.add(rightEnd);

            }

          }else {
            System.out.println("direction not 0 or 1");
          }
          
        //add path to corridor list
        Corridor c = new Corridor(path);
        corList.add(c);
        }

    return;
            
  }



}
