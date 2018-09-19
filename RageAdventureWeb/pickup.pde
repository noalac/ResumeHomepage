class HeroPickup extends Pickup {
  HeroPickup(String name, String spritesheet, int rows, int columns, float x, float y, boolean visible) {
    super(name, spritesheet, rows, columns, x, y, visible);
  }
}

class Coin extends HeroPickup {
  Coin(float x, float y) {
    super("Coin", "graphics/item/coin.gif", 1, 1, x, y, true);
    SoundManager.load(this, "audio/gold.mp3");
  }
  void pickedUp(Pickup pickup) {
    SoundManager.play(this);
  }
}

class Key extends HeroPickup {
  Key(float x, float y) {
    super("Key", "graphics/item/key.gif", 1, 1, x, y, true);
    SoundManager.load(this, "audio/gear.mp3");
  }

  void pickedUp(Pickup pickup) {
    SoundManager.play(this);
    // the key is actually a trap!
    ragelayer.addBoundedInteractor(new SawBlock("left", 808, 200));
    ragelayer.addBoundedInteractor(new SawBlock("right", 984, 200));
  }
}


