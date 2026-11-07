package flashx.textLayout.operations
{
   import flashx.textLayout.edit.SelectionState;
   import flashx.textLayout.elements.FlowElement;
   
   [Deprecated(replacement="ApplyFormatToElementOperation",deprecatedSince="2.0")]
   public class ApplyElementStyleNameOperation extends FlowElementOperation
   {
      
      private var _origStyleName:String;
      
      private var _newStyleName:String;
      
      public function ApplyElementStyleNameOperation(operationState:SelectionState, targetElement:FlowElement, newStyleName:String, relativeStart:int = 0, relativeEnd:int = -1)
      {
         this._newStyleName = newStyleName;
         super(operationState,targetElement,relativeStart,relativeEnd);
      }
      
      public function get newStyleName() : String
      {
         return this._newStyleName;
      }
      
      public function set newStyleName(val:String) : void
      {
         this._newStyleName = val;
      }
      
      override public function doOperation() : Boolean
      {
         var targetElement:FlowElement = getTargetElement();
         this._origStyleName = targetElement.styleName;
         adjustForDoOperation(targetElement);
         targetElement.styleName = this._newStyleName;
         return true;
      }
      
      override public function undo() : SelectionState
      {
         var targetElement:FlowElement = getTargetElement();
         targetElement.styleName = this._origStyleName;
         adjustForUndoOperation(targetElement);
         return originalSelectionState;
      }
   }
}

