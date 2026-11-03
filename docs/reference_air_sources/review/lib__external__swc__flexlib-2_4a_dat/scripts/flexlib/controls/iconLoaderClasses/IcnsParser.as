package flexlib.controls.iconLoaderClasses
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Endian;
   
   public class IcnsParser implements IIconParser
   {
      
      private var _data:ByteArray;
      
      private var _sizes:Array = [];
      
      private var _validIcon:Boolean = false;
      
      private var _masks:Dictionary = new Dictionary();
      
      private var _bitmaps:Dictionary = new Dictionary();
      
      public function IcnsParser()
      {
         super();
      }
      
      private static function fourCharCode(s:String) : int
      {
         var ba:ByteArray = null;
         var result:int = 0;
         ba = new ByteArray();
         ba.endian = Endian.BIG_ENDIAN;
         ba.writeUTFBytes(s);
         ba.position = 0;
         return ba.readInt();
      }
      
      private static function decompressBitmap(bm:ByteArray, channelLen:int) : ByteArray
      {
         var result:ByteArray = null;
         var red:ByteArray = null;
         var blue:ByteArray = null;
         var green:ByteArray = null;
         var channel:ByteArray = null;
         var k:int = 0;
         var i:int = 0;
         var b:uint = 0;
         var runLen:uint = 0;
         var val:uint = 0;
         var j:int = 0;
         var pixel:uint = 0;
         result = new ByteArray();
         red = new ByteArray();
         blue = new ByteArray();
         green = new ByteArray();
         bm.position = 0;
         for each(channel in [red,green,blue])
         {
            i = 0;
            while(i < channelLen)
            {
               b = bm.readUnsignedByte();
               if(Boolean(b & 0x80))
               {
                  val = bm.readUnsignedByte();
                  runLen = b - 125;
                  for(j = 0; j < runLen; j++)
                  {
                     channel.writeByte(val);
                  }
               }
               else
               {
                  runLen = b + 1;
                  channel.writeBytes(bm,bm.position,runLen);
                  bm.position += runLen;
               }
               i += runLen;
            }
         }
         red.position = 0;
         green.position = 0;
         blue.position = 0;
         for(k = 0; k < channelLen; k++)
         {
            pixel = uint(0xFF000000 | red.readUnsignedByte() << 16 | green.readUnsignedByte() << 8 | blue.readUnsignedByte());
            result.writeInt(pixel);
         }
         return result;
      }
      
      private static function mergeAlpha(bm:BitmapData, alpha:BitmapData) : BitmapData
      {
         var r:Rectangle = null;
         var bitmapPixels:ByteArray = null;
         var alphaPixels:ByteArray = null;
         var merged:ByteArray = null;
         var result:BitmapData = null;
         var c:uint = 0;
         var a:uint = 0;
         if(bm.width != alpha.width || bm.height != alpha.height)
         {
            throw new Error("Alpha and bitmap dimensions do not match");
         }
         r = new Rectangle(0,0,bm.width,bm.height);
         bitmapPixels = bm.getPixels(r);
         alphaPixels = alpha.getPixels(r);
         merged = new ByteArray();
         result = new BitmapData(r.width,r.height);
         bitmapPixels.position = 0;
         alphaPixels.position = 0;
         while(bitmapPixels.bytesAvailable > 0)
         {
            c = bitmapPixels.readUnsignedInt();
            a = alphaPixels.readUnsignedInt();
            merged.writeInt(a | c & 0xFFFFFF);
         }
         merged.position = 0;
         result.setPixels(r,merged);
         return result;
      }
      
      private function processIcon(iconType:int) : Boolean
      {
         var result:Boolean = false;
         result = false;
         if(iconType == fourCharCode("is32"))
         {
            result = process32BitIcon(16);
         }
         else if(iconType == fourCharCode("s8mk"))
         {
            result = process8BitMask(16);
         }
         else if(iconType == fourCharCode("il32"))
         {
            result = process32BitIcon(32);
         }
         else if(iconType == fourCharCode("l8mk"))
         {
            result = process8BitMask(32);
         }
         else if(iconType == fourCharCode("ih32"))
         {
            result = process32BitIcon(48);
         }
         else if(iconType == fourCharCode("h8mk"))
         {
            result = process8BitMask(48);
         }
         else if(iconType == fourCharCode("it32"))
         {
            result = process32BitIcon(128);
         }
         else if(iconType == fourCharCode("t8mk"))
         {
            result = process8BitMask(128);
         }
         else
         {
            result = skipIcon();
         }
         return result;
      }
      
      public function getIconForSize(s:int) : BitmapData
      {
         var oldS:int = 0;
         if(_sizes.indexOf(s) == -1)
         {
            oldS = s;
            for each(s in _sizes)
            {
               if(s < oldS)
               {
                  break;
               }
            }
         }
         if(_bitmaps[s] == undefined || _masks[s] == undefined)
         {
            return null;
         }
         return mergeAlpha(_bitmaps[s],_masks[s]);
      }
      
      public function get sizes() : Array
      {
         return _sizes;
      }
      
      public function set data(val:ByteArray) : void
      {
         _data = val;
         _data.position = 0;
         _data.endian = Endian.BIG_ENDIAN;
      }
      
      private function skipIcon() : Boolean
      {
         var result:Boolean = false;
         var len:int = 0;
         result = true;
         len = _data.readInt() - 8;
         _data.position += len;
         return result;
      }
      
      public function get validIcon() : Boolean
      {
         return _validIcon;
      }
      
      private function ReadHeader() : Boolean
      {
         var marker:int = 0;
         var len:int = 0;
         marker = _data.readInt();
         len = _data.readInt();
         if(marker == fourCharCode("icns") && len == _data.length)
         {
            _validIcon = true;
         }
         return _validIcon;
      }
      
      public function get data() : ByteArray
      {
         return _data;
      }
      
      private function process8BitMask(s:int) : Boolean
      {
         var result:Boolean = false;
         var len:int = 0;
         var ba:ByteArray = null;
         var bmd:BitmapData = null;
         var i:int = 0;
         var b:int = 0;
         result = true;
         len = _data.readInt() - 8;
         ba = new ByteArray();
         bmd = new BitmapData(s,s,true);
         for(i = 0; i < len; i++)
         {
            b = int(_data.readUnsignedByte());
            ba.writeInt(b << 24);
         }
         ba.position = 0;
         bmd.setPixels(new Rectangle(0,0,s,s),ba);
         _masks[s] = bmd;
         if(_bitmaps[s] != undefined && _sizes.indexOf(s) == -1)
         {
            _sizes.push(s);
            _sizes = _sizes.sort(Array.NUMERIC | Array.DESCENDING);
         }
         return result;
      }
      
      public function parse() : void
      {
         var result:Boolean = false;
         var iconType:int = 0;
         result = ReadHeader();
         if(!result)
         {
            return;
         }
         while(_data.bytesAvailable >= 4)
         {
            iconType = _data.readInt();
            result = processIcon(iconType);
            if(!result)
            {
               break;
            }
         }
      }
      
      private function process32BitIcon(s:int) : Boolean
      {
         var result:Boolean = false;
         var len:int = 0;
         var ba:ByteArray = null;
         var bmd:BitmapData = null;
         result = true;
         len = _data.readInt() - 8;
         ba = new ByteArray();
         bmd = new BitmapData(s,s,true);
         ba.writeBytes(_data,_data.position,len);
         _data.position += len;
         ba = decompressBitmap(ba,s * s);
         ba.position = 0;
         bmd.setPixels(new Rectangle(0,0,s,s),ba);
         _bitmaps[s] = bmd;
         if(_masks[s] != undefined && _sizes.indexOf(s) == -1)
         {
            _sizes.push(s);
            _sizes = _sizes.sort(Array.NUMERIC | Array.DESCENDING);
         }
         return result;
      }
   }
}

