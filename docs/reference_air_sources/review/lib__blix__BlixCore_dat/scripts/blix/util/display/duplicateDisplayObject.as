package blix.util.display
{
   import flash.display.DisplayObject;
   
   public function duplicateDisplayObject(param1:DisplayObject) : DisplayObject
   {
      if(param1 == null)
      {
         return null;
      }
      var _loc2_:DisplayObject = new (param1 as Object).constructor() as DisplayObject;
      _loc2_.transform.matrix = param1.transform.matrix;
      _loc2_.filters = param1.filters.slice();
      _loc2_.accessibilityProperties = param1.accessibilityProperties;
      _loc2_.alpha = param1.alpha;
      _loc2_.blendMode = param1.blendMode;
      _loc2_.cacheAsBitmap = param1.cacheAsBitmap;
      _loc2_.visible = param1.visible;
      _loc2_.mask = param1.mask;
      _loc2_.opaqueBackground = param1.opaqueBackground;
      _loc2_.scale9Grid = param1.scale9Grid;
      _loc2_.scrollRect = param1.scrollRect;
      if(param1.parent != null)
      {
         param1.parent.addChild(_loc2_);
      }
      return _loc2_;
   }
}

