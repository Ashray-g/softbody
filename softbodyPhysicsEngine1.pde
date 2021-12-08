
//change
double side = 25;
int xS = 10;
int yS = 15;
double Km = 500;
double xB = 0.998;
double xI = 0;
double yI = 0;
//change

double[] xPoints;
double[] yPoints;
double[] xVels;
double[] yVels;
ArrayList<spring>[] adList;

double springRelaxed = side;
double diag = sqrt((float)side * (float)side * 2);
double gravity = 9.8;

void setup(){
  size(500, 400);
  stroke(255);
  background(192, 64, 0);
  createPairs();

}
//0 1 2
//3 4 5
//6 7 8

void pair(int a, int b, double len){
  adList[a].add(new spring(b, len));
}
void pair(int a, int b){
  adList[a].add(new spring(b));
}
int[][] index;
void createPairs(){
   adList = new ArrayList[xS * yS];
   index = new int[yS][xS];

  for(int i = 0;i<xS * yS;i++){
    adList[i] = new ArrayList<>();
  }
  int ct = 0;
  for(int i = 0;i<yS;i++){
    for(int j = 0;j<xS;j++){
      index[i][j] = ct;
      ct++;
    }
  }
  int[] aDx = {1, 0, -1, 0};
  int[] aDy = {0, -1, 0, 1};
  int[] dDx = {-1, -1, 1, 1};
  int[] dDy = {-1, 1, -1, 1};
  
  for(int i = 0;i<yS;i++){
    for(int j = 0;j<xS;j++){
      
      for(int a = 0;a<4;a++){
        int nx = j + aDx[a];
        int ny = i + aDy[a];
        
        int nx2 = j + dDx[a];
        int ny2 = i + dDy[a];
        
        if(nx >= 0 && nx < xS && ny >=0 && ny < yS){
          pair(index[i][j], index[ny][nx]);
          println(i + " " + j);
        }
        if(nx2 >= 0 && nx2 < xS && ny2 >=0 && ny2 < yS){
          pair(index[i][j], index[ny2][nx2], diag);
        }
      }
    }
  }
  
  xPoints = new double[xS * yS];
  yPoints = new double[xS * yS];
  xVels = new double[xS * yS];
  yVels = new double[xS * yS];
  int xCt = 0;
  int yCt = 0;
  for(int i = 0;i<xS * yS;i++){
    xVels[i] = xI;
    yVels[i] = yI;
    xPoints[i] = 40 + xCt*side;
    yPoints[i] = 200 + yCt*side;
    xCt++;
    if(xCt == xS){
      xCt = 0;
      yCt++;
    }
  }
  xVels[2] = -20;
  
}

class spring{
  public double relaxed = side;
  public double K = Km;
  public double curStrech = side;
  public double lastLen = side;
  public int point;
  
  public spring(int point){
    this.point = point;
  }
  
  public spring(int point, double relax){
    this.point = point;
    this.relaxed = relax;
    this.curStrech = relax;
    this.lastLen = relax;
  }
}

int lastMouseX = 0;
int lastMouseY = 0;

void draw(){
  
  background(112, 167, 255);
  line(0, 350, 800, 350);
  line(400, 0, 400, 500);
  line(1, 0, 1, 500);
  
  //draw springs
  stroke(60);
  for(int i = 0;i<yS*xS;i++){
    boolean edge = false;
    if(adList[i].size() <=5){
      edge = true;
    }
    for(int j =0;j<adList[i].size();j++){

      line(
        (float)xPoints[i], 
        (float)yPoints[i], 
        (float)xPoints[adList[i].get(j).point], 
        (float)yPoints[adList[i].get(j).point]
      );
    }

  }
  stroke(255);
  //draw points
  for(int i = 0;i<xS*yS;i++){
    circle((float)xPoints[i], (float)yPoints[i], 5f);
  }
  //apply gravity
  for(int i = 0;i<xS*yS;i++){
    yVels[i] += gravity/100;
  }
  //spring
  spring();
  
  //damp x
  for(int x = 0;x<xS*yS;x++){
    xVels[x] = xVels[x] * xB;
  }
  //add bounce
  for(int i = 0;i<xS*yS;i++){
    if(yPoints[i] > 347.5 && yVels[i] > 0){
      yVels[i] = -yVels[i]/1.1;
    }
    if(xPoints[i] > 397.5 && xVels[i] > 0){
      xVels[i] = -xVels[i]/1.1;
    }
    if(xPoints[i] < 3.5 && xVels[i] < 0){
      xVels[i] = -xVels[i]/1.1;
    }
  }
  //move points by vel
  for(int i = 0;i<xS*yS;i++){
    xPoints[i] += xVels[i];
    yPoints[i] += yVels[i];
  }
  
  if(mousePressed){
    
    int xCt = 0;
    int yCt = 0;
    for(int i = 0;i<xS * yS;i++){
      xVels[i] = mouseX - lastMouseX;
      yVels[i] = mouseY - lastMouseY;
      xPoints[i] = mouseX + xCt*side;
      yPoints[i] = mouseY + yCt*side;
      xCt++;
      if(xCt == xS){
        xCt = 0;
        yCt++;
      }
    }
    lastMouseX = mouseX;
    lastMouseY = mouseY;
  }

  

}

void spring(){

  for(int a = 0;a<xS*yS;a++){
    for(spring b : adList[a]){
      double x1 = xPoints[a];
      double y1 = yPoints[a];
      double x2 = xPoints[b.point];
      double y2 = yPoints[b.point];
      
      double lastLen = b.lastLen;
      double cur = b.curStrech;
      double relax = b.relaxed;
      double k = b.K;
      
      double distX = ((float)x1 -  x2);
      double distY = ((float)y1 - y2);
      double strech = sqrt((float)(distX * distX + distY * distY));
      double change = cur - lastLen;
      b.lastLen = strech;
   
      double Fs = -k * (relax - strech) + change*20;
      if(Fs > 6000){
        Fs = 6000;
      } 
      if(Fs < -6000){
        Fs = -6000;
      }
      println(Fs);
      yVels[a] += -(Fs/1000)*((float)(distY / (abs((float)distX) + abs((float)distY))));
      xVels[a] += -(Fs/1000)*((float)(distX / (abs((float)distX) + abs((float)distY))));

    }
  }
  //delay(200);
}
