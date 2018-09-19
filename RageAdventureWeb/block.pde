/**
 * Perhaps unexpected, blocks can also be
 * interactors. They get bonked just like
 * enemies, and they do things based on the
 * interaction.
 */
abstract class SpecialBlock extends BoundedInteractor {

  // how many things do we hold?
  int content = 1;

  // constructor just do ordinary things
  SpecialBlock(String name, float x, float y) {
    super(name);
    setPosition(x,y);
    setForces(0,0);
    setAcceleration(0,0);
  }

  void addBoundaryAround(float x, float y, int width, int height) {
    // add boundary around block
    // up bound, will NOT detected overlap
    addBoundary(new Boundary(x-width/2-1,y-height/2-1,x+width/2+1,y-height/2-1));
    // down bound, will detected overlap
    addBoundary(new Boundary(x+width/2+1,y+height/2-2,x-width/2-1,y+height/2-2));
    // left bound, will NOT detected overlap
    addBoundary(new Boundary(x-width/2-1,y+height/2,x-width/2-1,y-height/2));
    // right bound, will NOT detected overlap
    addBoundary(new Boundary(x+width/2+1,y-height/2,x+width/2+1,y+height/2));
  }

  abstract void reaction();
}

// BrickBlock is just ordinary block
class BrickBlock extends SpecialBlock {
  BrickBlock(String picname, float x, float y) {
    super("BrickBlock", x, y);
    content = 0;
    setupStates(picname);
    addBoundaryAround(x, y, width, height);
  }

  void setupStates(String pic) {
    addState( new State("showing", "graphics/item/"+pic+".gif", 1, 1) );
  }

  void reaction() { /* do nothing */ }
}

// I am sorry but if lady is a block, everything will be easy
class Lady extends SpecialBlock {
  Lady(String picname, float x, float y) {
    super("Lady", x, y);
    content = 0;
    setupStates(picname);
    // minus 24, lady can be touched or run into from any direction
    addBoundaryAround(x, y, width-24, height-24);
  }

  void setupStates(String pic) {
    addState( new State("standing", "graphics/item/"+pic+".gif", 1, 1) );
  }

  void reaction() { ragelayer.hero.win(); }
}


// show go information
class InfoBlock extends SpecialBlock {
  InfoBlock(float x, float y) {
    super("InfoBlock", x, y);
    content = 1;
    setupStates();
    // width add 4 to make hero totally safe from side touch
    addBoundaryAround(x, y, width+4, height);
  }

  void setupStates() {
    // when just hanging in the level
    addState(new State("hanging","graphics/item/go.gif",1,1));
  }

  void reaction() {
    // show the sharp saws if not falling
    Sprite saws = new Sprite("graphics/enemy/saw.gif");
    // be aware that infoblock is 240 wide and 96 height
    TilingSprite blocksaw = new TilingSprite(saws, 240, 256, 480, 269);
    ragelayer.addBackgroundSprite(blocksaw);

    // stop the falling block
    setForces(0,0);
    // and let hero die!
    ragelayer.hero.die();
  }
}

// FallBlock will fall when touch on top
class FallBlock extends SpecialBlock {
  FallBlock(float x, float y) {
    super("FallBlock", x, y);
    content = 1;
    setupStates();
  }

  void setupStates() {
    // when just hanging in the level
    addState(new State("idle","graphics/background/ground.gif",1,1));
  }

  void reaction() {
    setForces(0, DOWN_FORCE);
    setImpulseCoefficients(DAMPENING, DAMPENING);
    addImpulse(0, 20);
  }
}

// unknownblock is a special block, hit it and an info appears
class UnknownBlock extends SpecialBlock {
  UnknownBlock(float x, float y) {
    super("UnknownBlock", x, y);
    content = 1;
    setupStates();
    addBoundaryAround(x, y, width, height);
  }

  void setupStates() {
    // when just hanging in the level
    State hanging = new State("hanging","graphics/item/unknown.gif",1,1);
    addState(hanging);

    // when we've run out of things to spit out
    State exhausted = new State("exhausted","graphics/item/block.gif",1,1);
    addState(exhausted);
    SoundManager.load(exhausted, "audio/gold.mp3");

    setCurrentState("hanging");
  }

  void reaction() {
    if (active.name=="hanging") {
      setCurrentState("exhausted");
      SoundManager.play(active);

      // Test for add a coin
      ragelayer.addForPlayerOnly(new Coin(180, 180));

      // infoblock is a global variable      
      infoblock = new InfoBlock(360, 210);
      ragelayer.addBoundedInteractor(infoblock);

      // add a trigger to let info block falls
      ragelayer.addTrigger(new InfoTrigger(400, screenHeight-200, 5, screenHeight));
    }
  }
}

// hiddenblock is a special block, cannot see
class HiddenBlock extends SpecialBlock {
  float posx;
  float posy;
  float value;
  HiddenBlock(float x, float y, float act) {
    super("HiddenBlock", x, y);
    content = 1;
    this.posx = x;
    this.posy = y;
    this.value = act;
    setupStates();

    // down bound only
    addBoundary(new Boundary(x+23,y+22,x-23,y+22));
  }

  void setupStates() {
    State showing = new State("showing", "graphics/item/block.gif", 1, 1);
    SoundManager.load(showing, "audio/gold.mp3");
    addState(showing);

    State hiding = new State("hiding", "graphics/item/hidden.gif", 1, 1);
    addState(hiding);
  }

  void reaction() {
    //println(ragelayer.hero.getBoundingBox()[1]);
    // value is set at initialization
    if((active.name!="showing") &&
       (value==ragelayer.hero.getBoundingBox()[1])) {
      addBoundaryAround(posx, posy, 48, 48);
      setCurrentState("showing");
      SoundManager.play(active);
   }
  }
}


// saw on the left or right
class SawBlock extends SpecialBlock {
  SawBlock(String direction, float x, float y) {
    super("SawBlock", x, y);
    content = 1;
    setupStates(direction);
    // width minus 4 is important to let hero hit into the saw
    addBoundaryAround(x, y, width-4, height);
  }

  void setupStates(String dir) {
    addState(new State("hanging","graphics/enemy/saw"+dir+".gif",1,1));
  }

  void reaction() { ragelayer.hero.die(); }
}

