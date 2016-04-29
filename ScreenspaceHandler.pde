/**
 * The ScreenspaceHandler Class
 * 
 * A class that holds and calculates variables for the display view on the 'canvas'
 */
class ScreenspaceHandler {
  int canvasWidth, canvasHeight, viewX, viewY, viewWidth, viewHeight;
  double viewScale;
  
  ScreenspaceHandler(int canWidth, int canHeight) {
    this.canvasWidth = canWidth;
    this.canvasHeight = canHeight;
    
    //Default view values, size is 1600x900 at a 1.0 scale
    //Center the view
    this.viewX = 0;
    this.viewY = 0;
    this.viewWidth = 1600;
    this.viewHeight = 900;
    this.viewScale = 1.0;
  }
  
  /**
   * Move the view to these exact coordinates on the canvas
   * 
   * @param newViewX  X pos of new location
   * @param newViewY  Y pos of new location
   */
  void MoveView(int newViewX, int newViewY) {
    //Set the new view position, making sure that we don't get OOB errors
    this.viewX = Utils.Clamp(0, this.canvasWidth - (int)(this.viewWidth/this.viewScale), newViewX);
    this.viewY = Utils.Clamp(0, this.canvasWidth - (int)(this.viewWidth/this.viewScale), newViewY);
  }
  
  /**
   * Scale the view to a new distance
   * 
   * @param multiplier  View scale. Automatically gets clamped to be between 0.1 and 2.0
   */
  void ScaleView(double multiplier) {
    this.viewScale = Utils.ClampDouble(0.1, 2.0, multiplier);
    this.MoveView(this.viewX, this.viewY);
  }
}