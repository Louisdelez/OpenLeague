package spark.components.supportClasses
{
   import flash.display.BlendMode;
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.ContextMenu;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.container.TextContainerManager;
   import flashx.textLayout.edit.EditingMode;
   import flashx.textLayout.edit.ElementRange;
   import flashx.textLayout.edit.IEditManager;
   import flashx.textLayout.edit.ISelectionManager;
   import flashx.textLayout.edit.SelectionFormat;
   import flashx.textLayout.edit.SelectionManager;
   import flashx.textLayout.edit.SelectionState;
   import flashx.textLayout.elements.IConfiguration;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.elements.TextRange;
   import flashx.textLayout.events.SelectionEvent;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.operations.ApplyFormatOperation;
   import flashx.textLayout.operations.InsertTextOperation;
   import flashx.undo.IUndoManager;
   import flashx.undo.UndoManager;
   import mx.events.SandboxMouseEvent;
   import mx.styles.IStyleClient;
   import spark.components.RichEditableText;
   import spark.components.TextSelectionHighlighting;
   
   [ExcludeClass]
   public class RichEditableTextContainerManager extends TextContainerManager
   {
      
      private var hasScrollRect:Boolean = false;
      
      private var textDisplay:RichEditableText;
      
      public function RichEditableTextContainerManager(container:RichEditableText, configuration:IConfiguration = null)
      {
         super(container,configuration);
         this.textDisplay = container;
      }
      
      override public function drawBackgroundAndSetScrollRect(scrollX:Number, scrollY:Number) : Boolean
      {
         var backgroundColor:* = undefined;
         var width:Number = Number(this.textDisplay.width);
         var height:Number = Number(this.textDisplay.height);
         var contentBounds:Rectangle = getContentBounds();
         if(isNaN(width))
         {
            width = contentBounds.right;
         }
         if(isNaN(height))
         {
            height = contentBounds.bottom;
         }
         var xOrigin:Number = 0;
         if(scrollX == 0 && scrollY == 0 && contentBounds.left >= xOrigin && contentBounds.right <= width && contentBounds.top >= 0 && contentBounds.bottom <= height)
         {
            if(this.hasScrollRect)
            {
               container.scrollRect = null;
               this.hasScrollRect = false;
            }
         }
         else
         {
            container.scrollRect = new Rectangle(scrollX,scrollY,width,height);
            this.hasScrollRect = true;
         }
         var color:uint = 0;
         var alpha:Number = 0;
         var styleableContainer:IStyleClient = container as IStyleClient;
         if(Boolean(styleableContainer))
         {
            backgroundColor = styleableContainer.getStyle("backgroundColor");
            if(backgroundColor !== undefined)
            {
               color = uint(backgroundColor);
               alpha = Number(styleableContainer.getStyle("backgroundAlpha"));
            }
         }
         var g:Graphics = container.graphics;
         g.clear();
         g.lineStyle();
         g.beginFill(color,alpha);
         g.drawRect(scrollX,scrollY,width,height);
         g.endFill();
         return this.hasScrollRect;
      }
      
      override §§namespace("http://ns.adobe.com/textLayout/internal/2008") function getContextMenu() : ContextMenu
      {
         return this.textDisplay.contextMenu != null ? null : super.getContextMenu();
      }
      
      override protected function getUndoManager() : IUndoManager
      {
         if(!this.textDisplay.undoManager)
         {
            this.textDisplay.undoManager = new UndoManager();
            this.textDisplay.undoManager.undoAndRedoItemLimit = int.MAX_VALUE;
         }
         return this.textDisplay.undoManager;
      }
      
      override protected function getFocusedSelectionFormat() : SelectionFormat
      {
         var selectionColor:* = this.textDisplay.getStyle("focusedTextSelectionColor");
         var focusedPointAlpha:Number = editingMode == EditingMode.READ_WRITE ? 1 : 0;
         return new SelectionFormat(selectionColor,1,BlendMode.NORMAL,0,focusedPointAlpha,BlendMode.INVERT);
      }
      
      override protected function getUnfocusedSelectionFormat() : SelectionFormat
      {
         var unfocusedSelectionColor:* = this.textDisplay.getStyle("unfocusedTextSelectionColor");
         var unfocusedAlpha:Number = this.textDisplay.selectionHighlighting != TextSelectionHighlighting.WHEN_FOCUSED ? 1 : 0;
         return new SelectionFormat(unfocusedSelectionColor,unfocusedAlpha,BlendMode.NORMAL,unfocusedSelectionColor,0);
      }
      
      override protected function getInactiveSelectionFormat() : SelectionFormat
      {
         var inactiveSelectionColor:* = this.textDisplay.getStyle("inactiveTextSelectionColor");
         var inactiveAlpha:Number = this.textDisplay.selectionHighlighting == TextSelectionHighlighting.ALWAYS ? 1 : 0;
         return new SelectionFormat(inactiveSelectionColor,inactiveAlpha,BlendMode.NORMAL,inactiveSelectionColor,0);
      }
      
      override protected function createEditManager(undoManager:IUndoManager) : IEditManager
      {
         var editManager:IEditManager = super.createEditManager(undoManager);
         editManager.allowDelayedOperations = this.textDisplay.batchTextInput;
         editManager.delayUpdates = false;
         return editManager;
      }
      
      override public function setText(text:String) : void
      {
         super.setText(text);
         this.initForInputIfHaveFocus();
      }
      
      override public function setTextFlow(textFlow:TextFlow) : void
      {
         super.setTextFlow(textFlow);
         this.initForInputIfHaveFocus();
      }
      
      private function initForInputIfHaveFocus() : void
      {
         var im:ISelectionManager = null;
         var controller:ContainerController = null;
         if(editingMode != EditingMode.READ_ONLY && this.textDisplay.getFocus() == this.textDisplay)
         {
            im = beginInteraction();
            controller = getTextFlow().flowComposer.getControllerAt(0);
            controller.requiredFocusInHandler(null);
            if(!this.textDisplay.preserveSelectionOnSetText)
            {
               im.selectRange(0,0);
            }
            endInteraction();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function applyFormatOperation(leafFormat:ITextLayoutFormat, paragraphFormat:ITextLayoutFormat, containerFormat:ITextLayoutFormat, anchorPosition:int, activePosition:int) : Boolean
      {
         var textFlow:TextFlow = null;
         var absoluteStart:int = 0;
         var absoluteEnd:int = 0;
         if(anchorPosition == -1 || activePosition == -1)
         {
            return true;
         }
         textFlow = this.getTextFlowWithComposer();
         var operationState:SelectionState = new SelectionState(textFlow,anchorPosition,activePosition);
         var editManager:IEditManager = textFlow.interactionManager as IEditManager;
         if(Boolean(editManager))
         {
            absoluteStart = this.getAbsoluteStart(anchorPosition,activePosition);
            absoluteEnd = this.getAbsoluteEnd(anchorPosition,activePosition);
            if(editManager.absoluteStart == absoluteStart && editManager.absoluteEnd == absoluteEnd)
            {
               operationState.selectionManagerOperationState = true;
            }
         }
         var op:ApplyFormatOperation = new ApplyFormatOperation(operationState,leafFormat,paragraphFormat,containerFormat);
         var success:Boolean = Boolean(op.doOperation());
         if(success)
         {
            textFlow.normalize();
            textFlow.flowComposer.updateAllControllers();
         }
         return success;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getCommonCharacterFormat(anchorPosition:int, activePosition:int) : ITextLayoutFormat
      {
         var range:TextRange = null;
         var selRange:ElementRange = null;
         if(anchorPosition == -1 || activePosition == -1)
         {
            return null;
         }
         var textFlow:TextFlow = this.getTextFlowWithComposer();
         if(Boolean(textFlow.interactionManager))
         {
            range = new TextRange(textFlow,anchorPosition,activePosition);
            return textFlow.interactionManager.getCommonCharacterFormat(range);
         }
         selRange = ElementRange.createElementRange(textFlow,anchorPosition,activePosition);
         return selRange.getCommonCharacterFormat();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getCommonContainerFormat() : ITextLayoutFormat
      {
         var textFlow:TextFlow = this.getTextFlowWithComposer();
         var selRange:ElementRange = ElementRange.createElementRange(textFlow,0,textFlow.textLength - 1);
         return selRange.getCommonContainerFormat();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getCommonParagraphFormat(anchorPosition:int, activePosition:int) : ITextLayoutFormat
      {
         if(anchorPosition == -1 || activePosition == -1)
         {
            return null;
         }
         var textFlow:TextFlow = this.getTextFlowWithComposer();
         var selRange:ElementRange = ElementRange.createElementRange(textFlow,anchorPosition,activePosition);
         return selRange.getCommonParagraphFormat();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function insertTextOperation(insertText:String, anchorPosition:int, activePosition:int) : Boolean
      {
         var insertPt:int = 0;
         var selectionState:SelectionState = null;
         var selectionEvent:SelectionEvent = null;
         if(anchorPosition == -1 || activePosition == -1)
         {
            return false;
         }
         var textFlow:TextFlow = this.getTextFlowWithComposer();
         var absoluteStart:int = this.getAbsoluteStart(anchorPosition,activePosition);
         var absoluteEnd:int = this.getAbsoluteEnd(anchorPosition,activePosition);
         var pointFormat:ITextLayoutFormat = this.getCommonCharacterFormat(absoluteStart,absoluteStart);
         var operationState:SelectionState = new SelectionState(textFlow,absoluteStart,absoluteEnd,pointFormat);
         operationState.selectionManagerOperationState = true;
         var op:InsertTextOperation = new InsertTextOperation(operationState,insertText);
         var success:Boolean = Boolean(op.doOperation());
         if(success)
         {
            textFlow.normalize();
            textFlow.flowComposer.updateAllControllers();
            insertPt = absoluteEnd - (absoluteEnd - absoluteStart) + insertText.length;
            selectionState = new SelectionState(textFlow,insertPt,insertPt);
            selectionEvent = new SelectionEvent(SelectionEvent.SELECTION_CHANGE,false,false,selectionState);
            textFlow.dispatchEvent(selectionEvent);
            scrollToRange(insertPt,insertPt);
         }
         return success;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getTextFlowWithComposer() : TextFlow
      {
         var editManager:IEditManager = null;
         var textFlow:TextFlow = getTextFlow();
         if(composeState != TextContainerManager.COMPOSE_COMPOSER)
         {
            convertToTextFlowWithComposer();
         }
         else if(Boolean(textFlow.interactionManager))
         {
            editManager = textFlow.interactionManager as IEditManager;
            if(Boolean(editManager) && Boolean(editManager.delayUpdates))
            {
               editManager.updateAllControllers();
            }
            else
            {
               textFlow.interactionManager.flushPendingOperations();
            }
         }
         return textFlow;
      }
      
      private function getAbsoluteStart(anchorPosition:int, activePosition:int) : int
      {
         return anchorPosition < activePosition ? anchorPosition : activePosition;
      }
      
      private function getAbsoluteEnd(anchorPosition:int, activePosition:int) : int
      {
         return anchorPosition > activePosition ? anchorPosition : activePosition;
      }
      
      override public function focusInHandler(event:FocusEvent) : void
      {
         this.textDisplay.focusInHandler(event);
         super.focusInHandler(event);
      }
      
      override public function focusOutHandler(event:FocusEvent) : void
      {
         this.textDisplay.focusOutHandler(event);
         super.focusOutHandler(event);
      }
      
      override public function keyDownHandler(event:KeyboardEvent) : void
      {
         var clone:KeyboardEvent = null;
         this.textDisplay.keyDownHandler(event);
         if(!event.isDefaultPrevented())
         {
            clone = KeyboardEvent(event.clone());
            super.keyDownHandler(clone);
            if(clone.isDefaultPrevented())
            {
               event.preventDefault();
            }
         }
      }
      
      override public function keyUpHandler(event:KeyboardEvent) : void
      {
         var clone:KeyboardEvent = null;
         if(!event.isDefaultPrevented())
         {
            clone = KeyboardEvent(event.clone());
            super.keyUpHandler(clone);
            if(clone.isDefaultPrevented())
            {
               event.preventDefault();
            }
         }
      }
      
      override public function mouseDownHandler(event:MouseEvent) : void
      {
         this.textDisplay.mouseDownHandler(event);
         super.mouseDownHandler(event);
      }
      
      override public function activateHandler(event:Event) : void
      {
         var im:SelectionManager = null;
         if(event.type == Event.ACTIVATE)
         {
            return;
         }
         super.activateHandler(event);
         if(editingMode != EditingMode.READ_ONLY && this.textDisplay.getFocus() == this.textDisplay)
         {
            im = SelectionManager(beginInteraction());
            im.setFocus();
            endInteraction();
         }
      }
      
      override public function deactivateHandler(event:Event) : void
      {
         if(event.type == Event.DEACTIVATE)
         {
            return;
         }
         super.deactivateHandler(event);
      }
      
      override public function beginMouseCapture() : void
      {
         super.beginMouseCapture();
         this.textDisplay.systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.mouseUpSomewhereHandler);
         this.textDisplay.systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE,this.mouseMoveSomewhereHandler);
      }
      
      override public function endMouseCapture() : void
      {
         super.endMouseCapture();
         this.textDisplay.systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.mouseUpSomewhereHandler);
         this.textDisplay.systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE,this.mouseMoveSomewhereHandler);
      }
      
      private function mouseUpSomewhereHandler(event:Event) : void
      {
         mouseUpSomewhere(event);
      }
      
      private function mouseMoveSomewhereHandler(event:Event) : void
      {
         mouseMoveSomewhere(event);
      }
   }
}

