import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20 
public final static int NUM_ROWS = 20; public final static int NUM_COLS = 20; public final static int NUM_BOMBS = 50;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS;r++) {
      for(int c = 0; c < NUM_ROWS;c++)
        buttons[r][c] = new MSButton(r,c);
    }
    
    setMines();
}
public void setMines()
{
  while(bombs.size() < NUM_BOMBS){
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if(bombs.contains(buttons[r][c]) == false){
      bombs.add(buttons[r][c]);
      System.out.println(r + ", " + c);
    }
  }
}

public void draw ()
{
    background( 0 );
    System.out.println(isLose());
    if(isWon() == true)
        displayWinningMessage();
  
}
public boolean isLose()
{
    for(int i = NUM_ROWS-1; i >= 0; i--){
      for(int q = NUM_COLS-1; q >= 0; q--){
        if(bombs.contains(buttons[i][q])){
          return true;
        }
      }
    }
      return false;
}
public boolean isWon()
{
    int winSum = 0;
    for(int i = NUM_ROWS-1; i >= 0; i--){
      for(int q = NUM_COLS-1; q >= 0; q--){
        if(buttons[i][q].getClicked() && !bombs.contains(buttons[i][q]))
          winSum++;
      }
      if(winSum == NUM_ROWS * NUM_COLS - bombs.size()){
        return true;
      }
    }
      return false;
      
}
public void displayLosingMessage()
{
 if(isLose() == true){
      buttons[NUM_ROWS/2 - 1][NUM_COLS/2 - 4].setLabel("Y");
      buttons[NUM_ROWS/2 - 1][NUM_COLS/2 - 3].setLabel("O");
      buttons[NUM_ROWS/2 - 1][NUM_COLS/2 - 2].setLabel("U");
      buttons[NUM_ROWS/2 - 1][NUM_COLS/2 - 1].setLabel(" ");
      buttons[NUM_ROWS/2 - 1][NUM_COLS/2].setLabel("L");
      buttons[NUM_ROWS/2 - 1][NUM_COLS/2 + 1].setLabel("O");
      buttons[NUM_ROWS/2 - 1][NUM_COLS/2 + 2].setLabel("S");
      buttons[NUM_ROWS/2 - 1][NUM_COLS/2 + 3].setLabel("E");
      noLoop();
      for(int i = 0; i < bombs.size();i++) {
        bombs.get(i).clicked = true;
        System.out.println(i);
      }
   }  
}
public void displayWinningMessage()
{
     if(isWon() == true && mousePressed == true){
        buttons[NUM_ROWS/2 - 1][NUM_COLS/2 - 4].setLabel("Y");
        buttons[NUM_ROWS/2 - 1][NUM_COLS/2 - 3].setLabel("O");
        buttons[NUM_ROWS/2 - 1][NUM_COLS/2 - 2].setLabel("U");
        buttons[NUM_ROWS/2 - 1][NUM_COLS/2 - 1].setLabel(" ");
        buttons[NUM_ROWS/2 - 1][NUM_COLS/2].setLabel("W");
        buttons[NUM_ROWS/2 - 1][NUM_COLS/2 + 1].setLabel("I");
        buttons[NUM_ROWS/2 - 1][NUM_COLS/2 + 2].setLabel("N");
      noLoop();
    }
    
}
public boolean isValid(int r, int c)
{ 
    if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
      return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row-1; r <= row+1;r++){
      for(int c = col-1; c <= col+1;c++){
        if(isValid(r,c) && bombs.contains(buttons[r][c])){
          numMines++;
          }
        }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {   
 
        if(mouseButton == LEFT && !flagged){
          clicked = true;
        if(bombs.contains(this)){
            displayLosingMessage();
            
          } 
   
          else if(countMines(myRow, myCol) > 0){
            setLabel(countMines(myRow, myCol));
          }
          else if(!isFlagged()) {
          for(int r = -1; r <= 1; r++) {
            C_LOOP: for(int c = -1; c <= 1; c++) {
              if(!isValid(myRow + r, myCol + c) || buttons[myRow + r][myCol + c].getClicked() || buttons[myRow + r][myCol + c].isFlagged())
                continue C_LOOP;
              else
                buttons[myRow + r][myCol + c].mousePressed();
            }
          }
        }
        }  
        if(mouseButton == RIGHT && clicked == false){
          flagged = !flagged;
        } 
     }
     
   public boolean getClicked() 
   {
     return clicked;
   }
    public void draw () 
    {    
        if (flagged)
            fill(0,255,255);
        else if(clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
