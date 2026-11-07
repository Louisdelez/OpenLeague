package flexlib.controls.iconLoaderClasses
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Endian;
   
   public class IcoParser implements IIconParser
   {
      
      private static const BI_RGB:int = 0;
      
      private static const BI_RLE8:int = 1;
      
      private static const BI_RLE4:int = 2;
      
      private static const BI_BITFIELDS:int = 3;
      
      private var _data:ByteArray;
      
      private var _sizes:Array = [];
      
      private var _validIcon:Boolean = false;
      
      private var _numIcons:int;
      
      private var _iconDirEntries:Array = [];
      
      private var _iconImages:Dictionary = new Dictionary();
      
      public function IcoParser()
      {
         super();
      }
      
      private function processImage(bm:ByteArray) : ByteArray
      {
         var result:ByteArray = null;
         var b:uint = 0;
         var g:uint = 0;
         var r:uint = 0;
         var a:uint = 0;
         var color:uint = 0;
         result = new ByteArray();
         result.endian = Endian.LITTLE_ENDIAN;
         bm.position = 0;
         while(bm.bytesAvailable >= 4)
         {
            b = bm.readUnsignedByte();
            g = bm.readUnsignedByte();
            r = bm.readUnsignedByte();
            a = bm.readUnsignedByte();
            color = uint(a << 24 | r << 16 | g << 8 | b);
            result.writeUnsignedInt(color);
         }
         return result;
      }
      
      public function getIconForSize(s:int) : BitmapData
      {
         var result:BitmapData = null;
         var icon:IconImage = null;
         var ba:ByteArray = null;
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
         result = new BitmapData(s,s);
         icon = _iconImages[s] as IconImage;
         ba = processImage(icon.icXOR);
         ba.position = 0;
         result.setPixels(new Rectangle(0,0,s,s),ba);
         mirrorBitmap(result);
         return result;
      }
      
      private function mirrorBitmap(bmd:BitmapData) : void
      {
         var i:int = 0;
         var r1:Rectangle = null;
         var line1:ByteArray = null;
         var r2:Rectangle = null;
         var line2:ByteArray = null;
         for(i = 0; i < bmd.height / 2; i++)
         {
            r1 = new Rectangle(0,i,bmd.width,1);
            line1 = bmd.getPixels(r1);
            r2 = new Rectangle(0,bmd.height - i - 1,bmd.width,1);
            line2 = bmd.getPixels(r2);
            line1.position = 0;
            line2.position = 0;
            bmd.setPixels(r1,line2);
            bmd.setPixels(r2,line1);
         }
      }
      
      public function get sizes() : Array
      {
         return _sizes;
      }
      
      public function set data(val:ByteArray) : void
      {
         _data = val;
         _data.position = 0;
         _data.endian = Endian.LITTLE_ENDIAN;
      }
      
      public function get validIcon() : Boolean
      {
         return _validIcon;
      }
      
      private function parseHeader() : Boolean
      {
         var idReserved:uint = 0;
         var idType:uint = 0;
         idReserved = _data.readUnsignedShort();
         idType = _data.readUnsignedShort();
         if(idReserved != 0 || idType != 1)
         {
            return false;
         }
         _numIcons = _data.readUnsignedShort();
         return true;
      }
      
      private function parseIconImages() : Boolean
      {
         var dir:IconDirEntry = null;
         var header:BitmapInfoHeader = null;
         var iconImage:IconImage = null;
         var colorTableLen:int = 0;
         var imageLen:int = 0;
         for each(dir in _iconDirEntries)
         {
            _data.position = dir.dwImageOffset;
            header = new BitmapInfoHeader();
            header.biSize = _data.readUnsignedInt();
            header.biWidth = _data.readUnsignedInt();
            header.biHeight = _data.readUnsignedInt();
            header.biPlanes = _data.readUnsignedShort();
            header.biBitCount = _data.readUnsignedShort();
            header.biCompression = _data.readUnsignedInt();
            header.biSizeImage = _data.readUnsignedInt();
            header.biXPelsPerMeter = _data.readUnsignedInt();
            header.biYPelsPerMeter = _data.readUnsignedInt();
            header.biClrUsed = _data.readUnsignedInt();
            header.biClrImportant = _data.readUnsignedInt();
            if(header.biBitCount < 24)
            {
               _data.position = dir.dwImageOffset + dir.dwBytesInRes;
            }
            else
            {
               iconImage = new IconImage();
               iconImage.icHeader = header;
               iconImage.icAND = new ByteArray();
               iconImage.icXOR = new ByteArray();
               colorTableLen = 0;
               if(header.biBitCount == 32 && header.biCompression == BI_BITFIELDS)
               {
                  colorTableLen = 12;
               }
               _data.position += colorTableLen;
               imageLen = header.biHeight / 2 * header.biWidth * 4;
               iconImage.icXOR.writeBytes(_data,_data.position,imageLen);
               _iconImages[dir.bWidth] = iconImage;
               _sizes.push(dir.bWidth);
               _sizes.sort(Array.NUMERIC | Array.DESCENDING);
            }
         }
         return true;
      }
      
      public function get data() : ByteArray
      {
         return _data;
      }
      
      private function parseIconDirs() : Boolean
      {
         var i:int = 0;
         var iconDirEntry:IconDirEntry = null;
         for(i = 0; i < _numIcons; i++)
         {
            iconDirEntry = new IconDirEntry();
            iconDirEntry.bWidth = _data.readUnsignedByte();
            iconDirEntry.bHeight = _data.readUnsignedByte();
            iconDirEntry.bColorCount = _data.readUnsignedByte();
            iconDirEntry.bReserved = _data.readUnsignedByte();
            iconDirEntry.wPlanes = _data.readUnsignedShort();
            iconDirEntry.wBitCount = _data.readUnsignedShort();
            iconDirEntry.dwBytesInRes = _data.readUnsignedInt();
            iconDirEntry.dwImageOffset = _data.readUnsignedInt();
            _iconDirEntries.push(iconDirEntry);
         }
         return true;
      }
      
      public function parse() : void
      {
         _validIcon = parseHeader();
         if(_validIcon)
         {
            _validIcon = parseIconDirs();
         }
         if(_validIcon)
         {
            _validIcon = parseIconImages();
         }
      }
   }
}

import flash.utils.ByteArray;

class BitmapInfoHeader
{
   
   public var biWidth:int;
   
   public var biHeight:int;
   
   public var biSizeImage:int;
   
   public var biPlanes:int;
   
   public var biXPelsPerMeter:int;
   
   public var biYPelsPerMeter:int;
   
   public var biCompression:int;
   
   public var biClrImportant:int;
   
   public var biSize:int;
   
   public var biBitCount:int;
   
   public var biClrUsed:int;
   
   public function BitmapInfoHeader()
   {
      super();
   }
}

class IconDirEntry
{
   
   public var dwImageOffset:int;
   
   public var bWidth:int;
   
   public var bHeight:int;
   
   public var bReserved:int;
   
   public var wPlanes:int;
   
   public var bColorCount:int;
   
   public var wBitCount:int;
   
   public var dwBytesInRes:int;
   
   public function IconDirEntry()
   {
      super();
   }
}

class IconImage
{
   
   public var icXOR:ByteArray;
   
   public var icColors:ByteArray;
   
   public var icHeader:BitmapInfoHeader;
   
   public var icAND:ByteArray;
   
   public function IconImage()
   {
      super();
   }
}
