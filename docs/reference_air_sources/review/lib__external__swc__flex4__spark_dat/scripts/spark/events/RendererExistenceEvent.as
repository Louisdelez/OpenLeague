package spark.events
{
   import flash.events.Event;
   import mx.core.IVisualElement;
   
   public class RendererExistenceEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const RENDERER_ADD:String = "rendererAdd";
      
      public static const RENDERER_REMOVE:String = "rendererRemove";
      
      public var data:Object;
      
      public var index:int;
      
      public var renderer:IVisualElement;
      
      public function RendererExistenceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, renderer:IVisualElement = null, index:int = -1, data:Object = null)
      {
         super(type,bubbles,cancelable);
         this.renderer = renderer;
         this.index = index;
         this.data = data;
      }
      
      override public function clone() : Event
      {
         return new RendererExistenceEvent(type,bubbles,cancelable,this.renderer,this.index,this.data);
      }
   }
}

