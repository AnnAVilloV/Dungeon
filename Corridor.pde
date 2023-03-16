final class Corridor{
    ArrayList<Room> rooms = new ArrayList<Room>();
    
    Corridor(ArrayList<point> path){
      if(path.size() == 2){ // - type

        point p1, p2;
        if(path.get(0).x == path.get(1).x){ //vertical corridor
            if(path.get(0).y < path.get(1).y){
              p1 = path.get(0);
              p2 = path.get(1);
            }else{
              p2 = path.get(0);
              p1 = path.get(1);
            }
            point topLeft = new point(p1.x - HALFCOR, p1.y);
            int rwidth = 2*HALFCOR;
            int rheight = Math.abs(p1.y - p2.y);
            Room r = new Room(topLeft, rwidth, rheight);
            rooms.add(r);
        }else if(path.get(0).y == path.get(1).y){ // horizontal corridor
           if(path.get(0).x < path.get(1).x){
              p1 = path.get(0);
              p2 = path.get(1);
           }else{
              p2 = path.get(0);
              p1 = path.get(1);
           }
           point topLeft = new point(p1.x, p1.y - HALFCOR);
           int rwidth = Math.abs(p1.x-p2.x);
           int rheight = 2*HALFCOR;
           Room r = new Room(topLeft, rwidth, rheight);
           rooms.add(r);
        }
      
      }else{ // z type
        point center = path.get(0);
        point p1,p2,p3,p4;
        if(path.get(1).x == path.get(2).x){ //vertical
           if(path.get(1).y < path.get(2).y){
             p1 = path.get(1);
             p2 = path.get(2);
             p3 = path.get(3);
             p4 = path.get(4);
           }else{
             p2 = path.get(1);
             p1 = path.get(2);
             p4 = path.get(3);
             p3 = path.get(4);
           }
           //generate vertical z type corridor
           if(p3.x < p1.x){
             //r1
             point rp1 = new point(p3.x, p3.y - HALFCOR);
             int rw1 = Math.abs(p3.x - p1.x) + HALFCOR;
             int rh1 = 2*HALFCOR;
             Room r1 = new Room(rp1, rw1, rh1);
             //r2
             point rp2 = new point(center.x-HALFCOR, p1.y+HALFCOR);
             int rw2 = 2*HALFCOR;
             int rh2 = Math.abs(p1.y - p2.y) - 2*HALFCOR;
             Room r2 = new Room(rp2,rw2,rh2);
             //r3
             point rp3 = new point(p2.x - HALFCOR, p2.y - HALFCOR);
             int rw3 = Math.abs(p2.x - p4.x) + HALFCOR;
             int rh3 = 2*HALFCOR;
             Room r3 = new Room(rp3,rw3,rh3);
             
             rooms.add(r1);rooms.add(r2);rooms.add(r3);
           }else{
             //r1
             point rp1 = new point(p1.x - HALFCOR, p1.y - HALFCOR);
             int rw1 = Math.abs(p3.x - p1.x) + HALFCOR;
             int rh1 = 2*HALFCOR;
             Room r1 = new Room(rp1, rw1, rh1);
             //r2
             point rp2 = new point(center.x-HALFCOR, center.y - Math.abs(p2.y - p1.y)/2 + HALFCOR);
             int rw2 = 2*HALFCOR;
             int rh2 = Math.abs(p1.y - p2.y) - 2*HALFCOR;
             Room r2 = new Room(rp2,rw2,rh2);
             //r3
             point rp3 = new point(p4.x, p4.y - HALFCOR);
             int rw3 = Math.abs(p2.x - p4.x) + HALFCOR;
             int rh3 = 2*HALFCOR;
             Room r3 = new Room(rp3,rw3,rh3);
             
             rooms.add(r1);rooms.add(r2);rooms.add(r3);
           }
           
           
        }else if(path.get(1).y == path.get(2).y){ //horizontal
          if(path.get(1).x < path.get(2).x){
            p1 = path.get(1);
            p2 = path.get(2);
            p3 = path.get(3);
            p4 = path.get(4);
          }else{
            p2 = path.get(1);
            p1 = path.get(2);
            p4 = path.get(3);
            p3 = path.get(4);
          }
        //generate z type corridor
        if(p3.y<p1.y){
             //r1
             point rp1 = new point(p3.x -HALFCOR, p3.y);
             int rw1 = 2*HALFCOR; 
             int rh1 = Math.abs(p3.y - p1.y) + HALFCOR;
             Room r1 = new Room(rp1, rw1, rh1);
             //r2
             point rp2 = new point(p1.x + HALFCOR, p1.y - HALFCOR);
             int rw2 = Math.abs(p1.x - p2.x) - 2*HALFCOR;
             int rh2 = 2*HALFCOR;
             Room r2 = new Room(rp2,rw2,rh2);
             //r3
             point rp3 = new point(p2.x - HALFCOR, p2.y - HALFCOR);
             int rw3 = 2*HALFCOR;
             int rh3 = Math.abs(p2.y - p4.y) + HALFCOR;
             Room r3 = new Room(rp3,rw3,rh3);
             
             rooms.add(r1);rooms.add(r2);rooms.add(r3);

        }else{
             //r1
             point rp1 = new point(p1.x - HALFCOR, p1.y - HALFCOR);
             int rw1 = 2*HALFCOR; 
             int rh1 = Math.abs(p3.y - p1.y) + HALFCOR;
             Room r1 = new Room(rp1, rw1, rh1);
             //r2
             point rp2 = new point(p1.x + HALFCOR, p1.y - HALFCOR);
             int rw2 = Math.abs(p1.x - p2.x) - 2*HALFCOR;
             int rh2 = 2*HALFCOR;
             Room r2 = new Room(rp2,rw2,rh2);
             //r3
             point rp3 = new point(p4.x - HALFCOR, p4.y);
             int rw3 = 2*HALFCOR;
             int rh3 = Math.abs(p2.y - p4.y) + HALFCOR;
             Room r3 = new Room(rp3,rw3,rh3);
             
             rooms.add(r1);rooms.add(r2);rooms.add(r3);

        }
        }

        
      
      }

    }
    
    void draw(){
      for(Room r: rooms){
        r.draw();
      }
    
    }



}
