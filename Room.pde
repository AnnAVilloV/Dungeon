final class Room{
  point topLeft;
  point bottomRight;
  int roomWidth;
  int roomHeight;
  BSPnode mynode=null;
  
  Room(point topLeft, int rwidth, int rheight){
    this.topLeft = topLeft;
    this.roomWidth = rwidth;
    this.roomHeight = rheight;
    this.bottomRight = new point(topLeft.x + rwidth,topLeft.y + rheight);
  }
  
  Room(int x1, int y1, int x2, int y2){
    topLeft = new point(x1,y1);
    bottomRight = new point(x2, y2);
    this.roomWidth = x2-x1;
    this.roomHeight = y2-y1;
  }
  
 Room(int x1, int y1, int x2, int y2, BSPnode node){
    topLeft = new point(x1,y1);
    bottomRight = new point(x2, y2);
    this.roomWidth = x2-x1;
    this.roomHeight = y2-y1;
    this.mynode = node;
  }
  
  
  void draw(){
     fill(#CBC9C9);
     rect(topLeft.getXf(),topLeft.getYf() ,roomWidth, roomHeight) ;
          //text(mynode.depth,topLeft.getXf(),topLeft.getYf());
  }

}
  
