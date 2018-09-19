/*****************
 * RageAdventure *
 *****************/

final int screenWidth = 512;
final int screenHeight = 432;
 
float DOWN_FORCE = 2;      // gravity
float ACCELERATION = 1.3;  // gravity acceleration
float DAMPENING = 0.75;    // impluse movement

RageLevel ragelevel;
RageLayer ragelayer;
InfoBlock infoblock;    // will drop
Missile   missile;      // will fly

int IQ = 250;

void reset() {
  clearScreens();
  ragelevel = new RageLevel(4*width, height);
  addScreen("noalevel", ragelevel);
}

void initialize() {
  frameRate(24);
  reset();
}

class RageLevel extends Level {
  RageLevel(float levelWidth, float levelHeight) {
    super(levelWidth, levelHeight);

    // add the "far" background, at least looking so
    addLevelLayer("noabackground", new BackgroundLayer(this));

    // add playing layer
    ragelayer = new RageLayer(this);
    addLevelLayer("noalayer", ragelayer);

    // extend level width
    setViewBox(0, 0, screenWidth, screenHeight);

    // add some background music
    SoundManager.load(this, "audio/bgm.mp3");
    // attention! we wanna music play in loop, so dont just play
    SoundManager.loop(this);
  }
}

class BackgroundLayer extends LevelLayer {
  BackgroundLayer (Level owner) {
    super(owner, owner.width, owner.height, 0, 0, 0.75, 0.75);
    setBackgroundColor(color( random(200,255), random(200,255), random(200,255) ));
    addBackgroundSprite(new TilingSprite(new Sprite("graphics/background/skyfar.gif"), 0, 0, width, height));
  }
}

class RageLayer extends LevelLayer {
  Hero hero;

  RageLayer (Level owner) {
    super(owner);

    // background color and sprite
    Sprite background_picture = new Sprite("graphics/background/sky.gif");
    TilingSprite background = new TilingSprite(background_picture, 0, 0, width, height);
    addBackgroundSprite(background);

    // ground boundary
    addBoundary(new Boundary(0, 0, 0, height));
    addBoundary(new Boundary(width, height, width, 0));
    showBoundaries = true;

    // add ground with two holes in the middle
    addGround(-48, height-48, 480, height);
    addGround(624, height-48, 1670, height);
    addGround(1780, height-48, width+32, height);

    // add falling bricks to fill one hole
    addBoundedInteractor(new FallBlock(1706, height-24));
    addBoundedInteractor(new FallBlock(1754, height-24));

    // add blocks
    addBoundedInteractor(new UnknownBlock(180 , height-200));

    // add bricks
    // lower level
    addBoundedInteractor(new BrickBlock("brick", 800, height-160));
    addBoundedInteractor(new BrickBlock("unknown", 848, height-160));
    addBoundedInteractor(new BrickBlock("brick", 896, height-160));
    addBoundedInteractor(new BrickBlock("unknown", 944, height-160));
    addBoundedInteractor(new BrickBlock("brick", 992, height-160));
    // upper level
    addBoundedInteractor(new BrickBlock("brick", 848, height-300));
    addBoundedInteractor(new BrickBlock("unknown", 896, height-300));
    addBoundedInteractor(new BrickBlock("brick", 944, height-300));
    // add a coin inbetween
    addForPlayerOnly(new Key(896, height-210));

    // add two tubes, actually they are BrickBlocks
    // 120 = 72 + 48 : 48 is the height of groundbricks, 72 is half of the height of tubes
    addBoundedInteractor(new BrickBlock("tube", 1200, height-120));
    addBoundedInteractor(new BrickBlock("tube", 1536, height-120));
    addBoundedInteractor(new BrickBlock("block", 1138, height-72));

    // add hidden blocks, oh oh oh~
    // this one is at starting upon a valley
    addBoundedInteractor(new HiddenBlock(538, height-200, 255.5));
    // this five is between the two tubes
    addBoundedInteractor(new HiddenBlock(1272, height-172, 283.5));
    addBoundedInteractor(new HiddenBlock(1320, height-172, 283.5));
    addBoundedInteractor(new HiddenBlock(1368, height-172, 283.5));
    addBoundedInteractor(new HiddenBlock(1416, height-172, 283.5));
    addBoundedInteractor(new HiddenBlock(1464, height-172, 283.5));
    // this one is upon the tube
    addBoundedInteractor(new HiddenBlock(1300, 100, 123.5));

    // new a hero, and initialize position
    hero = new Hero(50, height-100);
    addPlayer(hero);

    // add your lady, hero~
    addBoundedInteractor(new Lady("lady", width-72, height-72));

    // add enemy static cloud/grass and movable slimes
    addInteractor(new StaticEnemy("cloud", 580, 70, true));
    addInteractor(new StaticEnemy("grass", 780, height-60, true));
    addInteractor(new Slime(1350, height-80));

    missile = new Missile(1536, screenHeight - 84)
    addInteractor(missile);
    // add trigger for missile
    addTrigger(new MissileTrigger(1536, 0, 5, screenHeight));
    // leave it show for temp
    //showTriggers = true;
  }

  void draw() {
    super.draw();
    viewbox.track(parent, hero);

    // add IQ text at beginning
    textSize(32);
    if (IQ <= -250) {
      text("Your hopeless IQ: "+IQ+" -_-||", 10, 40);
    } else { 
      text("Your IQ: "+IQ, 10, 40);
    }
    if (IQ > 100) {
      fill(0, 150, 0);
    } else if (IQ >= 0) {
      fill(0, 0, 200);
    } else {
      fill(250, 0, 0);
    }
  }

  void addGround(float x1, float y1, float x2, float y2) {
    Sprite grand = new Sprite("graphics/background/ground.gif");
    TilingSprite topland = new TilingSprite(grand, x1, y1, x2, y1+48);

    addBackgroundSprite(topland);

    // add boundary around
    addBoundary(new Boundary(x1, y1, x2, y1));
    addBoundary(new Boundary(x1, y2, x1, y1));
    addBoundary(new Boundary(x2, y1, x2, y2));
  }
}

