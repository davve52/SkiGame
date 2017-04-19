package core{
import de.flintfabrik.starling.extensions.FFParticleSystem;
import de.flintfabrik.starling.extensions.FFParticleSystem.rendering.FFParticleEffect;
import de.flintfabrik.starling.extensions.FFParticleSystem.styles.FFParticleStyle;

import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.text.TextField;

	public class Assets{
		
		[Embed(source= "/../assets/snow.png")]
		private static var BG:Class;
		
		[Embed(source= "/../assets/atlas.png")]
		private static var Atlas:Class;
		
		[Embed(source= "/../assets/atlas.xml", mimeType="application/octet-stream")]
		private static var AtlasXML:Class;
		
		[Embed(source= "/../assets/font.png")]
		private static var KomikaBitmap:Class;
		
		[Embed(source= "/../assets/font.fnt", mimeType="application/octet-stream")]
		private static var KomikaXML:Class;

        [Embed(source= "/../assets/crash.pex", mimeType="application/octet-stream")]
        public static var CrashXML:Class;

        [Embed(source= "/../assets/crash.png")]
        private static var TextureCrash:Class;
		
		public static var _ta:TextureAtlas;
		public static var _bgTexture:Texture;
		public static var _texture:Texture;
		
		public function Assets(){
			
		}
		
		public static function init():void{
			
			_bgTexture = Texture.fromBitmap(new BG);
			_ta = new TextureAtlas(Texture.fromBitmap(new Atlas()),XML(new AtlasXML));

           _texture = Texture.fromBitmap(new TextureCrash());
			
			var fontTexture:Texture = Texture.fromEmbeddedAsset(KomikaBitmap);
			var bmpFont:BitmapFont =  new BitmapFont(fontTexture,  XML(new KomikaXML)); 
			TextField.registerCompositor(bmpFont, "Komika");
			
			
            FFParticleSystem.defaultStyle = FFParticleStyle;
			if (!FFParticleSystem.poolCreated){ FFParticleSystem.initPool(1500, false);
				if(!FFParticleEffect.buffersCreated){ FFParticleEffect.createBuffers(1500, 2);
				}
			}
        }
	}
}