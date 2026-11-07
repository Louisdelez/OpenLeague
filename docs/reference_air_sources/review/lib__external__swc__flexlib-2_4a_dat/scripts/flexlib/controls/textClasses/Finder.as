package flexlib.controls.textClasses
{
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class Finder
   {
      
      private var caratIndex:int;
      
      private var textField:TextField;
      
      public function Finder(textField:TextField)
      {
         super();
         this.caratIndex = 0;
         this.textField = textField;
         this.textField.addEventListener(MouseEvent.CLICK,setCarat,false,1,true);
      }
      
      public function findPrevious(string:String, caseSensitive:Boolean = true) : int
      {
         var txt:String = null;
         var str:String = null;
         var len:int = 0;
         var i:int = 0;
         if(this.caratIndex == 0)
         {
            this.caratIndex = this.textField.text.length;
         }
         txt = this.textField.text;
         str = txt.substring(0,this.caratIndex);
         if(!caseSensitive)
         {
            txt = txt.toLowerCase();
            str = str.toLowerCase();
         }
         len = string.length;
         i = str.lastIndexOf(string);
         if(i == -1)
         {
            this.caratIndex = txt.length;
            i = txt.lastIndexOf(string);
         }
         if(i == -1)
         {
            return -1;
         }
         this.caratIndex = i;
         return i;
      }
      
      public function setCarat(evt:MouseEvent) : void
      {
         this.caratIndex = this.textField.caretIndex;
      }
      
      public function findNext(string:String, caseSensitive:Boolean = true) : int
      {
         var str:String = null;
         var len:int = 0;
         var i:int = 0;
         str = this.textField.text;
         if(!caseSensitive)
         {
            str = str.toLowerCase();
            string = string.toLowerCase();
         }
         len = string.length;
         i = str.indexOf(string,this.caratIndex + len);
         if(i == -1)
         {
            this.caratIndex = 0;
            i = str.indexOf(string,this.caratIndex);
         }
         if(i == -1)
         {
            return -1;
         }
         this.caratIndex = i + 1;
         return i;
      }
      
      public function indexesOf(string:String, caseSensitive:Boolean = true) : Array
      {
         var pos:int = 0;
         var r:Array = null;
         var txt:String = null;
         var len:int = 0;
         pos = 0;
         r = [];
         txt = this.textField.text;
         len = string.length;
         if(!caseSensitive)
         {
            txt = txt.toLowerCase();
            string = string.toLowerCase();
         }
         while(true)
         {
            pos = txt.indexOf(string,pos);
            if(pos == -1)
            {
               break;
            }
            r.push(pos);
            pos = pos + len;
            if(!(Boolean(pos)))
            {
               break;
            }
         }
         return r;
      }
   }
}

