package spark.components
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   
   [IconFile("Form.png")]
   [DiscouragedForProfile("mobileDevice")]
   public class Form extends SkinnableContainer
   {
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var errorStateChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _invalidElements:Array = new Array();
      
      public function Form()
      {
         super();
         addEventListener(FlexEvent.VALID,this.validHandler,true);
         addEventListener(FlexEvent.INVALID,this.invalidHandler,true);
         setStyle("showErrorSkin",false);
         setStyle("showErrorTip",false);
      }
      
      public function get invalidElements() : Array
      {
         return this._invalidElements;
      }
      
      private function errorStringChangedHandler(event:Event) : void
      {
         var elementIndex:int = 0;
         var uicElt:UIComponent = event.target as UIComponent;
         if(Boolean(uicElt) && uicElt.errorString == "")
         {
            elementIndex = this.findInvalidElementIndex(uicElt);
            if(elementIndex != -1)
            {
               this._invalidElements.splice(elementIndex,1);
            }
            uicElt.removeEventListener("errorStringChanged",this.errorStringChangedHandler);
            this.errorStateChanged = true;
            invalidateSkinState();
         }
      }
      
      private function validHandler(event:FlexEvent) : void
      {
         var elementIndex:int = 0;
         if(event.isDefaultPrevented())
         {
            return;
         }
         var targ:UIComponent = event.target as UIComponent;
         if(Boolean(targ))
         {
            elementIndex = this.findInvalidElementIndex(targ);
            if(elementIndex != -1)
            {
               this._invalidElements.splice(elementIndex,1);
            }
            targ.removeEventListener("errorStringChanged",this.errorStringChangedHandler);
         }
         this.errorStateChanged = true;
         invalidateSkinState();
      }
      
      private function invalidHandler(event:FlexEvent) : void
      {
         var position:Vector.<int> = null;
         var item:Object = null;
         if(event.isDefaultPrevented())
         {
            return;
         }
         var targ:UIComponent = event.target as UIComponent;
         if(Boolean(targ))
         {
            if(this.findInvalidElementIndex(targ) == -1)
            {
               position = this.getElementNestedPosition(targ,contentGroup);
               item = {
                  "element":targ,
                  "position":position
               };
               this._invalidElements.push(item);
               this._invalidElements.sort(this.compareNestedPosition);
               targ.addEventListener("errorStringChanged",this.errorStringChangedHandler);
            }
         }
         this.errorStateChanged = true;
         invalidateSkinState();
      }
      
      override protected function getCurrentSkinState() : String
      {
         var key:Object = null;
         var isEmpty:Boolean = false;
         var errMsg:String = null;
         var i:int = 0;
         var result:String = super.getCurrentSkinState();
         if(this.errorStateChanged)
         {
            this.errorStateChanged = false;
            isEmpty = true;
            errMsg = "";
            for(i = 0; i < this.invalidElements.length; i++)
            {
               isEmpty = false;
               if(errMsg != "")
               {
                  errMsg += "\n";
               }
               errMsg += UIComponent(this.invalidElements[i].element).errorString;
            }
            if(!isEmpty && enabled)
            {
               result = "error";
            }
            errorString = errMsg;
         }
         else if(enabled && this.invalidElements.length > 0)
         {
            result = "error";
         }
         return result;
      }
      
      private function compareNestedPosition(item1:Object, item2:Object) : int
      {
         var item1Value:int = 0;
         var item2Value:int = 0;
         var item1Pos:Vector.<int> = item1.position;
         var item2Pos:Vector.<int> = item2.position;
         var item1Depth:int = int(item1Pos.length);
         var item2Depth:int = int(item2Pos.length);
         var minDepth:int = Math.min(item1Depth,item2Depth);
         var currentDepth:int = 0;
         while(currentDepth < minDepth)
         {
            item1Value = item1Pos[currentDepth];
            item2Value = item2Pos[currentDepth];
            if(item1Value < item2Value)
            {
               return -1;
            }
            if(item1Value > item2Value)
            {
               return 1;
            }
            currentDepth++;
         }
         if(item1Depth < item2Depth)
         {
            return -1;
         }
         if(item1Depth > item2Depth)
         {
            return 1;
         }
         return 0;
      }
      
      private function findInvalidElementIndex(element:UIComponent) : int
      {
         for(var i:int = 0; i < this.invalidElements.length; i++)
         {
            if(element == this.invalidElements[i].element)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function getElementNestedPosition(target:DisplayObject, subTreeRoot:DisplayObjectContainer = undefined) : Vector.<int>
      {
         var p:DisplayObjectContainer = target.parent;
         var current:DisplayObject = target;
         var pos:Vector.<int> = new Vector.<int>();
         if(p == null || current == subTreeRoot)
         {
            pos.push(0);
         }
         else
         {
            while(p != null && current != subTreeRoot)
            {
               pos.splice(0,0,p.getChildIndex(current));
               current = p;
               p = p.parent;
            }
         }
         return pos;
      }
   }
}

