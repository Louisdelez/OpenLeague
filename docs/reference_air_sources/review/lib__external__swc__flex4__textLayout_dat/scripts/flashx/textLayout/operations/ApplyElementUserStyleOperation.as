package flashx.textLayout.operations
{
   import flashx.textLayout.edit.SelectionState;
   import flashx.textLayout.elements.FlowElement;
   
   [Deprecated(replacement="ApplyFormatToElementOperation",deprecatedSince="2.0")]
   public class ApplyElementUserStyleOperation extends FlowElementOperation
   {
      
      private var _styleName:String;
      
      private var _origValue:*;
      
      private var _newValue:*;
      
      public function ApplyElementUserStyleOperation(operationState:SelectionState, targetElement:FlowElement, styleName:String, value:*, relativeStart:int = 0, relativeEnd:int = -1)
      {
         this._styleName = styleName;
         this._newValue = value;
         super(operationState,targetElement,relativeStart,relativeEnd);
      }
      
      public function get styleName() : String
      {
         return this._styleName;
      }
      
      public function set styleName(val:String) : void
      {
         this._styleName = val;
      }
      
      public function get newValue() : *
      {
         return this._newValue;
      }
      
      public function set newValue(val:*) : void
      {
         this._newValue = val;
      }
      
      override public function doOperation() : Boolean
      {
         var targetElement:FlowElement = getTargetElement();
         this._origValue = targetElement.getStyle(this._styleName);
         adjustForDoOperation(targetElement);
         targetElement.setStyle(this._styleName,this._newValue);
         return true;
      }
      
      override public function undo() : SelectionState
      {
         var targetElement:FlowElement = getTargetElement();
         targetElement.setStyle(this._styleName,this._origValue);
         adjustForUndoOperation(targetElement);
         return originalSelectionState;
      }
   }
}

