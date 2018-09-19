/**
 * override!
 * this disables the default "loop()" when using addScreen
 */
void addScreen(String name, Screen screen) {
  screenSet.put(name, screen);
  if (activeScreen == null) { activeScreen = screen; }
  else { SoundManager.stop(activeScreen); }
}

/* @pjs pauseOnBlur="true";
        font="/RageAdventureWeb/fonts/acmesa.ttf";
        preload=" /RageAdventureWeb/graphics/mute.gif,
                  /RageAdventureWeb/graphics/unmute.gif,
                  /RageAdventureWeb/graphics/hero/standing-hero.gif,
                  /RageAdventureWeb/graphics/hero/walking-hero.gif,
                  /RageAdventureWeb/graphics/hero/jumping-hero.gif,
                  /RageAdventureWeb/graphics/hero/dead-hero.gif,
                  /RageAdventureWeb/graphics/background/sky.gif,
                  /RageAdventureWeb/graphics/background/ground.gif,
                  /RageAdventureWeb/graphics/background/skyfar.gif,
                  /RageAdventureWeb/graphics/item/lady.gif,
                  /RageAdventureWeb/graphics/item/coin.gif,
                  /RageAdventureWeb/graphics/item/block.gif,
                  /RageAdventureWeb/graphics/item/unknown.gif,
                  /RageAdventureWeb/graphics/item/go.gif,
                  /RageAdventureWeb/graphics/item/hidden.gif,
                  /RageAdventureWeb/graphics/item/brick.gif,
                  /RageAdventureWeb/graphics/item/key.gif,
                  /RageAdventureWeb/graphics/item/tube.gif,
                  /RageAdventureWeb/graphics/enemy/saw.gif,
                  /RageAdventureWeb/graphics/enemy/sawleft.gif,
                  /RageAdventureWeb/graphics/enemy/sawright.gif,
                  /RageAdventureWeb/graphics/enemy/cloud.gif,
                  /RageAdventureWeb/graphics/enemy/badcloud.gif,
                  /RageAdventureWeb/graphics/enemy/grass.gif,
                  /RageAdventureWeb/graphics/enemy/badgrass.gif,
                  /RageAdventureWeb/graphics/enemy/missile.gif,
                  /RageAdventureWeb/graphics/enemy/slime.gif"; */
