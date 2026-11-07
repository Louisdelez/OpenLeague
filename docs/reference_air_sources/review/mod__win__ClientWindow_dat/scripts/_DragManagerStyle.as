package
{
   import mx.core.IFlexModuleFactory;
   import mx.skins.halo.DefaultDragImage;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _DragManagerStyle
   {
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_DragReject_982828964:Class = _DragManagerStyle__embed_css_Assets_swf_mx_skins_cursor_DragReject_982828964;
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_DragLink_501050759:Class = _DragManagerStyle__embed_css_Assets_swf_mx_skins_cursor_DragLink_501050759;
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_DragMove_501074350:Class = _DragManagerStyle__embed_css_Assets_swf_mx_skins_cursor_DragMove_501074350;
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_DragCopy_499215378:Class = _DragManagerStyle__embed_css_Assets_swf_mx_skins_cursor_DragCopy_499215378;
      
      public function _DragManagerStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("DragManager");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("DragManager",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.copyCursor = _embed_css_Assets_swf_mx_skins_cursor_DragCopy_499215378;
               this.moveCursor = _embed_css_Assets_swf_mx_skins_cursor_DragMove_501074350;
               this.rejectCursor = _embed_css_Assets_swf_mx_skins_cursor_DragReject_982828964;
               this.linkCursor = _embed_css_Assets_swf_mx_skins_cursor_DragLink_501050759;
               this.defaultDragImageSkin = DefaultDragImage;
            };
         }
      }
   }
}

