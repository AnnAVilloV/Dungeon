final class Combat{
  PVector fighter = new PVector(displayWidth/5, displayHeight/2);
  PVector monster = new PVector(displayWidth*4/5, displayHeight/2);
  Enemy enemy;
  boolean round = true;
  int startTime;
  
  PVector test = new PVector(0,0);
  
 Combat(Enemy e){
 this.enemy = e;
 }
  
  void draw(){
    fill(#302E71);
    rect(0,0,displayWidth,displayHeight);

    
    image(humanImage,fighter.x-200,fighter.y-200,400,400);

    image(monsterImage,monster.x-200,monster.y-200,400,400);
    
    humanDraw();
    enemyDraw();
    
    barDraw();
    
    
    if(round){
      //human turn
        fill(255);
        float twidth = textWidth("Your Turn");
        text("Your Turn",displayWidth/2-twidth/2, displayHeight/3);
        
        if(addHP == true || addArmor == true){
           useItem();
        }else{
            if(physicAttack == true){
              attackPhy();
              physicAttack = false;
            }
            if(magicAttack == true){
              attackMagic();
              magicAttack = false;
            }
        }
      
    }else{
      //monster tern
      
      if(millis() - startTime < 1000){
        fill(255);
        float twidth = textWidth("Monster Turn");
        text("Monster Turn",displayWidth/2-twidth/2, displayHeight/3);
      }
      if (millis() - startTime > 1000){
        System.out.println("here!");
          monsterFight();
        } 

      
    }

}

void monsterFight(){
  if(enemy.nextAttack == "phy"){
        float bloodCut = enemy.phyAttack - human.armorValue;
      if(bloodCut <= 0){
        bloodCut = 0;
        enemy.nextAttack = "ma";
      }
      
      //human miss
      int miss = new Random().nextInt(1,1001);
      if(miss <= human.agility){
        bloodCut = 0;
      }
      
      human.HP -= bloodCut;
      if(human.HP <= 0){
        human.status = "dead";
        enemy.status = "roaming";
        //gameOver
        gameStatus = "gameOver";
      }
      round = !round;
  }else if(enemy.nextAttack == "ma"){
      float armorCut = enemy.magicAttack;
      human.armorValue -= armorCut;
      if(human.armorValue < 0){
        human.armorValue = 0;
      }
      
      int diceNext = new Random().nextInt(0,2);
      if(diceNext != 0){
        enemy.nextAttack = "phy";
      }
      
      round = !round;
  }
  
}
  
void attackMagic(){
  //float armorCut = human.magicAttack;
  float armorCut = new Random().nextInt((int)human.magicAttack - 1, (int)human.magicAttack + 8);
  enemy.armorValue -= armorCut;
  if(enemy.armorValue < 0){
    enemy.armorValue = 0;
  }
startTime = millis();
round = !round;
}
  
void attackPhy(){
  float bloodCut = human.phyAttack - enemy.armorValue;
  if(bloodCut < 0){
    bloodCut = 0;
  }
  //critical attack
  int crit = new Random().nextInt(1,1001);
  if(crit <= human.strength){
    bloodCut = bloodCut*(1.5);
  }
  
  
  enemy.HP -= bloodCut;
  if(enemy.HP <= 1){
    enemy.status = "dead";
    human.status = "normal";
    enemyList.remove(enemy);
    human.EXP += new Random().nextInt(8,16);
    //human.EXP += 100;
    if(human.EXP >= 100){
      human.levelUp();
    }
  }
  startTime = millis();
  round = !round;
}

  
void barDraw(){
  fill(#B5B7D3);
  rect(0,displayHeight*3/4,displayWidth,displayHeight/4);
  fill(0);
  text("Confront me, monster!", displayWidth*1/16, displayHeight*3/4+displayHeight*1/20);
  
  fill(#6B70C4);
  rect(displayWidth*1/16,displayHeight*3/4+displayHeight*1/10, displayWidth/5, displayHeight/10);
  rect(displayWidth*5/16,displayHeight*3/4+displayHeight*1/10, displayWidth/5, displayHeight/10);
  
  fill(0);
  text("Physical Attack",displayWidth*3/32,displayHeight*3/4+displayHeight*3/20);
  text("Magic Attack",displayWidth*5/16 + displayWidth*1/32,displayHeight*3/4+displayHeight*3/20);
}  
  
  
void enemyDraw(){
    fill(255);
    textSize(displayWidth/50);
    text(":HP",displayWidth*75/80,displayHeight*1/20);
    text(":Armor",displayWidth*75/80,displayHeight*2/20);

    //HP
    fill(#4BD331);
    rect(displayWidth*58/80,displayHeight*1/40,displayWidth/5,40);
    fill(#9782A5);
    rect(displayWidth*58/80,displayHeight*1/40,displayWidth/5*(enemy.HPlimit-enemy.HP)/enemy.HPlimit,40);
    
    //armorValue
    fill(#4B00FF);
    rect(displayWidth*66/80,displayHeight*6/80,displayWidth/10,30);
    fill(#9782A5);
    rect(displayWidth*66/80,displayHeight*6/80,displayWidth/10*(enemy.armorLimit-enemy.armorValue)/enemy.armorValue,30);
    

}
  
void humanDraw(){
  //character value boxes
    fill(255);
    textSize(displayWidth/50);
    text("HP: ",displayWidth*3/80,displayHeight*1/20);
    text("Armor: ",displayWidth*1/80,displayHeight*2/20);
    
    text(human.HP + "/"+human.HPlimit,displayWidth*6/80+displayWidth/5 + 10,displayHeight*1/20);
    text(human.armorValue + "/" + human.armorLimit,displayWidth*6/80+displayWidth/10 + 10,displayHeight*2/20);
    
    //HP
    fill(#9782A5);
    rect(displayWidth*6/80,displayHeight*1/40,displayWidth/5,40);
    fill(#4BD331);
    rect(displayWidth*6/80,displayHeight*1/40,displayWidth/5*human.HP/human.HPlimit,40);
    
    //armorValue
    fill(#9782A5);
    rect(displayWidth*6/80,displayHeight*6/80,displayWidth/10,30);
    fill(#4B00FF);
    rect(displayWidth*6/80,displayHeight*6/80,displayWidth/10*human.armorValue/human.armorLimit,30);
  
  }

}
