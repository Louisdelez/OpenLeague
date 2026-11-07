package mx.utils
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.display.StageDisplayState;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.IFlexDisplayObject;
   import mx.core.ILayoutElement;
   import mx.managers.ISystemManager;
   
   [ExcludeClass]
   public class PopUpUtil
   {
      
      public function PopUpUtil()
      {
         super();
      }
      
      public static function positionOverComponent(component:DisplayObject, systemManager:ISystemManager, popUpWidth:Number, popUpHeight:Number, verticalCenter:Number = NaN, popUpPosition:Point = null, regPoint:Point = null, ensureOnScreen:Boolean = true) : Point
      {
         var position:Point = null;
         var vc:Number = NaN;
         var screen:Rectangle = null;
         var topLeft:Point = null;
         var bottomRight:Point = null;
         var sm:ISystemManager = systemManager.topLevelSystemManager;
         var sbRoot:DisplayObject = sm.getSandboxRoot();
         var x:Number = 0;
         var y:Number = 0;
         if(Boolean(popUpPosition))
         {
            x = popUpPosition.x;
            y = popUpPosition.y;
         }
         else
         {
            if(!regPoint)
            {
               regPoint = new Point(0,0);
            }
            position = sbRoot.globalToLocal(component.localToGlobal(regPoint));
            x = position.x;
            y = position.y;
         }
         if(!isNaN(verticalCenter))
         {
            vc = sbRoot.globalToLocal(component.localToGlobal(new Point(0,verticalCenter))).y;
            y = vc - popUpHeight / 2;
         }
         if(ensureOnScreen)
         {
            screen = sm.getVisibleApplicationRect(null,true);
            topLeft = sbRoot.globalToLocal(screen.topLeft);
            bottomRight = sbRoot.globalToLocal(screen.bottomRight);
            x = Math.max(topLeft.x,Math.min(bottomRight.x - popUpWidth,x));
            y = Math.max(topLeft.y,Math.min(bottomRight.y - popUpHeight,y));
         }
         return new Point(x,y);
      }
      
      public static function applyPopUpTransform(owner:DisplayObjectContainer, colorTransform:ColorTransform, systemManager:ISystemManager, popUp:IFlexDisplayObject, popUpPoint:Point) : void
      {
         var smStage:Stage = null;
         var m:Matrix = MatrixUtil.getConcatenatedMatrix(owner,systemManager.getSandboxRoot());
         try
         {
            smStage = systemManager.stage;
            if(Boolean(smStage) && Boolean(smStage.displayState != StageDisplayState.NORMAL) && Boolean(smStage.fullScreenSourceRect))
            {
               popUpPoint.x += smStage.fullScreenSourceRect.x;
               popUpPoint.y += smStage.fullScreenSourceRect.y;
            }
         }
         catch(e:Error)
         {
         }
         m.tx = Math.round(popUpPoint.x);
         m.ty = Math.round(popUpPoint.y);
         if(popUp is ILayoutElement)
         {
            ILayoutElement(popUp).setLayoutMatrix(m,false);
         }
         else if(popUp is DisplayObject)
         {
            DisplayObject(popUp).transform.matrix = m;
         }
         var oldAlpha:Number = DisplayObject(popUp).alpha;
         var tmpColorTransform:ColorTransform = colorTransform;
         if(tmpColorTransform != null)
         {
            tmpColorTransform.alphaMultiplier = oldAlpha;
            tmpColorTransform.alphaOffset = 0;
         }
         DisplayObject(popUp).transform.colorTransform = tmpColorTransform;
      }
   }
}

