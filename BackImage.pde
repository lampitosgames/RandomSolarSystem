/**
 * The BackImage Class
 *
 * This is a wrapper class for the background PImage.
 * It adds the functionality of moving with the view at a reduced rate than the foreground, giving an illusion of parallax.
 */
class BackImage {
  //The PImage holding the galaxy background
  PImage FullBackground;
  
  /**
   * Constructor
   */
  BackImage() {
    //Load the background image and save it as a PShape
    FullBackground = loadImage("Galaxy2DBackground.jpg");
  }
  
  /**
   * Default Draw Method
   */
  void Draw() {
    //Draw the background as if it moved less than the foreground
    image(this.FullBackground, 0-(3946/2)+(width/2)-(screen.viewX/20), 0-(2160/2)+(height/2)-(screen.viewY/20), 3946, 2160); 
  }
}