package flash.printing
{
   import flash.display.Sprite;
   import flash.errors.*;
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   
   [native(cls="PrintJobClass",instance="PrintJobObject",methods="auto")]
   public class PrintJob extends EventDispatcher
   {
      
      private static const kGetPaperHeight:uint = 1;
      
      private static const kGetPaperWidth:uint = 3;
      
      private static const kGetPageHeight:uint = 5;
      
      private static const kGetPageWidth:uint = 7;
      
      private static const kGetOrientation:uint = 9;
      
      private static const kStart:uint = 100;
      
      private static const kAddPage:uint = 101;
      
      private static const kSend:uint = 102;
      
      private static const kSetOrientation:uint = 10;
      
      private static const kGetPrinter:uint = 11;
      
      private static const kSetPrinter:uint = 12;
      
      private static const kGetJobName:uint = 13;
      
      private static const kSetJobName:uint = 14;
      
      private static const kGetPaperArea:uint = 15;
      
      private static const kGetPrintableArea:uint = 17;
      
      private static const kGetMaxPixelsPerInch:uint = 19;
      
      private static const kGetIsColor:uint = 21;
      
      private static const kGetFirstPage:uint = 23;
      
      private static const kGetLastPage:uint = 25;
      
      private static const kGetCopies:uint = 27;
      
      private static const kSetCopies:uint = 28;
      
      private static const kShowPageSetupDialog:uint = 103;
      
      private static const kSelectPaperSize:uint = 104;
      
      private static const kStart2:uint = 105;
      
      private static const kTerminate:uint = 106;
      
      private var stubProperties:Object;
      
      public function PrintJob()
      {
         super();
      }
      
      [Version("10.1")]
      public static function get isSupported() : Boolean
      {
         return true;
      }
      
      [Version("air2.0")]
      public static native function get supportsPageSetupDialog() : Boolean;
      
      [Version("air2.0")]
      public static function get active() : Boolean
      {
         return activeInternal;
      }
      
      private static native function get activeInternal() : Boolean;
      
      [Version("air2.0")]
      public static native function get printers() : Vector.<String>;
      
      public function get paperHeight() : int
      {
         return this.invoke(kGetPaperHeight);
      }
      
      public function get paperWidth() : int
      {
         return this.invoke(kGetPaperWidth);
      }
      
      public function get pageHeight() : int
      {
         return this.invoke(kGetPageHeight);
      }
      
      public function get pageWidth() : int
      {
         return this.invoke(kGetPageWidth);
      }
      
      public function get orientation() : String
      {
         return this.invoke(kGetOrientation);
      }
      
      public function start() : Boolean
      {
         if(!this.lessThanAIR2)
         {
            if(this.thisJobIsActive)
            {
               return false;
            }
            if(PrintJob.activeInternal)
            {
               Error.throwError(IllegalOperationError,2141);
            }
         }
         return this.invoke(kStart) == true;
      }
      
      private native function invoke(param1:uint, ... rest) : *;
      
      private native function _invoke(param1:*, ... rest) : *;
      
      public function send() : void
      {
         this.invoke(kSend);
      }
      
      private function toClassicRectangle(printArea:Rectangle) : *
      {
         if(printArea != null)
         {
            return {
               "xMin":printArea.left,
               "yMin":printArea.top,
               "xMax":printArea.right,
               "yMax":printArea.bottom
            };
         }
         return null;
      }
      
      public function addPage(sprite:Sprite, printArea:Rectangle = null, options:PrintJobOptions = null, frameNum:int = 0) : void
      {
         var optionsConverted:Object = null;
         if(options != null)
         {
            optionsConverted = {
               "printAsBitmap":options.printAsBitmap,
               "printMethod":options.printMethod,
               "pixelsPerInch":options.pixelsPerInch
            };
         }
         if(this._invoke(kAddPage,sprite,this.toClassicRectangle(printArea),optionsConverted,frameNum > 0 ? frameNum : -1) == false)
         {
            Error.throwError(Error,2057);
         }
      }
      
      [Version("air2.0")]
      public function set orientation(orientStr:String) : void
      {
         if(orientStr != PrintJobOrientation.LANDSCAPE && orientStr != PrintJobOrientation.PORTRAIT)
         {
            Error.throwError(ArgumentError,2008,"PrintJobOrientation");
         }
         this.invoke(kSetOrientation,orientStr);
      }
      
      private native function get thisJobIsActive() : Boolean;
      
      [Version("air2.0")]
      public function get printer() : String
      {
         return this.invoke(kGetPrinter);
      }
      
      [Version("air2.0")]
      public function set printer(name:String) : void
      {
         this.invoke(kSetPrinter,name);
      }
      
      [Version("air2.0")]
      public function get jobName() : String
      {
         return this.invoke(kGetJobName);
      }
      
      [Version("air2.0")]
      public function set jobName(name:String) : void
      {
         if(this.thisJobIsActive)
         {
            Error.throwError(IllegalOperationError,2037);
         }
         this.invoke(kSetJobName,name);
      }
      
      [Version("air2.0")]
      public native function get paperArea() : Rectangle;
      
      [Version("air2.0")]
      public native function get printableArea() : Rectangle;
      
      [Version("air2.0")]
      public function get maxPixelsPerInch() : Number
      {
         return this.invoke(kGetMaxPixelsPerInch);
      }
      
      [Version("air2.0")]
      public function get isColor() : Boolean
      {
         return this.invoke(kGetIsColor);
      }
      
      [Version("air2.0")]
      public function get firstPage() : int
      {
         return this.invoke(kGetFirstPage);
      }
      
      [Version("air2.0")]
      public function get lastPage() : int
      {
         return this.invoke(kGetLastPage);
      }
      
      [Version("air2.0")]
      public function get copies() : int
      {
         return this.invoke(kGetCopies);
      }
      
      [Version("air2.0")]
      public function set copies(numCopies:int) : void
      {
         this.invoke(kSetCopies,numCopies);
      }
      
      [Version("air2.0")]
      public function showPageSetupDialog() : Boolean
      {
         if(!PrintJob.supportsPageSetupDialog)
         {
            Error.throwError(IllegalOperationError,2037);
         }
         if(PrintJob.activeInternal)
         {
            Error.throwError(IllegalOperationError,2141);
         }
         return this.invoke(kShowPageSetupDialog) != false;
      }
      
      [Version("air2.0")]
      public function selectPaperSize(paperSize:String) : void
      {
         if(paperSize != PaperSize.LETTER && paperSize != PaperSize.LEGAL && paperSize != PaperSize.EXECUTIVE && paperSize != PaperSize.STATEMENT && paperSize != PaperSize.FOLIO && paperSize != PaperSize.ENV_10 && paperSize != PaperSize.ENV_MONARCH && paperSize != PaperSize.A4 && paperSize != PaperSize.A5 && paperSize != PaperSize.A6 && paperSize != PaperSize.ENV_B5 && paperSize != PaperSize.JIS_B5 && paperSize != PaperSize.ENV_DL && paperSize != PaperSize.ENV_C5 && paperSize != PaperSize.CHOUKEI3GOU && paperSize != PaperSize.CHOUKEI4GOU && paperSize != PaperSize.ENV_PERSONAL)
         {
            Error.throwError(ArgumentError,2008,"PaperSize");
         }
         this.invoke(kSelectPaperSize,paperSize);
      }
      
      private native function get lessThanAIR2() : Boolean;
      
      [Version("air2.0")]
      public function start2(uiOptions:PrintUIOptions = null, showPrintDialog:Boolean = true) : Boolean
      {
         if(PrintJob.activeInternal)
         {
            Error.throwError(IllegalOperationError,2141);
         }
         var uiOptionsConverted:Object = null;
         if(uiOptions != null)
         {
            uiOptionsConverted = {
               "minPage":uiOptions.minPage,
               "maxPage":uiOptions.maxPage,
               "disablePageRange":uiOptions.disablePageRange
            };
         }
         return this.invoke(kStart2,uiOptionsConverted,showPrintDialog) != false;
      }
      
      [Version("air2.0")]
      public function terminate() : void
      {
         this.invoke(kTerminate);
      }
      
      private function initStubProperties() : void
      {
         this.stubProperties = new Object();
      }
      
      private function setStubProperty(key:String, value:*) : *
      {
         this.stubProperties[key] = value;
      }
      
      private function getStubProperty(key:String) : *
      {
         return this.stubProperties[key];
      }
   }
}

