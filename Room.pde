final class Room{
  point topLeft;
  point bottomRight;
  int roomWidth;
  int roomHeight;
  
  Room(int x1, int y1, int x2, int y2){
    topLeft = new point(x1,y1);
    bottomRight = new point(x2, y2);
    this.roomWidth = x2-x1;
    this.roomHeight = y2-y1;
  }
  
  void draw(){
     fill(#CBC9C9);
     rect(topLeft.getXf(),topLeft.getYf() ,roomWidth, roomHeight) ;
  }

}
  
