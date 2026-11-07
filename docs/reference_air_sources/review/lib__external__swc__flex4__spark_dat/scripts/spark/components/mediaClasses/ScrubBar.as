package spark.components.mediaClasses
{
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import mx.core.IVisualElement;
   import spark.components.HSlider;
   
   public class ScrubBar extends HSlider
   {
      
      private static var _skinParts:Object = {
         "dataTip":false,
         "track":false,
         "playedArea":false,
         "thumb":false,
         "loadedRangeArea":false
      };
      
      [SkinPart(required="false")]
      public var playedArea:IVisualElement;
      
      [SkinPart(required="false")]
      public var loadedRangeArea:IVisualElement;
      
      private var _loadedRangeEnd:Number;
      
      public function ScrubBar()
      {
         super();
         dataTipFormatFunction = this.formatTimeValue;
      }
      
      public function get loadedRangeEnd() : Number
      {
         return this._loadedRangeEnd;
      }
      
      public function set loadedRangeEnd(value:Number) : void
      {
         if(value == this._loadedRangeEnd)
         {
            return;
         }
         this._loadedRangeEnd = value;
         invalidateDisplayList();
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == this.playedArea)
         {
            if(this.playedArea is InteractiveObject)
            {
               InteractiveObject(this.playedArea).mouseEnabled = false;
            }
            if(this.playedArea is DisplayObjectContainer)
            {
               DisplayObjectContainer(this.playedArea).mouseChildren = false;
            }
            invalidateDisplayList();
         }
         else if(instance == this.loadedRangeArea)
         {
            if(this.loadedRangeArea is InteractiveObject)
            {
               InteractiveObject(this.loadedRangeArea).mouseEnabled = false;
            }
            if(this.loadedRangeArea is DisplayObjectContainer)
            {
               DisplayObjectContainer(this.loadedRangeArea).mouseChildren = false;
            }
            invalidateDisplayList();
         }
      }
      
      private function calculateAreaSize(value:Number) : Number
      {
         var trackPos:Number = Number(track.getLayoutBoundsX());
         var trackSize:Number = Number(track.getLayoutBoundsWidth());
         var thumbSize:Number = Number(thumb.getLayoutBoundsWidth());
         var range:Number = maximum - minimum;
         var thumbPos:Number = range > 0 ? (value - minimum) * ((trackSize - thumbSize) / range) : 0;
         return thumbSize + thumbPos;
      }
      
      override protected function updateSkinDisplayList() : void
      {
         super.updateSkinDisplayList();
         if(!thumb || !track)
         {
            return;
         }
         this.sizeLoadedRangeArea(this.calculateAreaSize(this.loadedRangeEnd));
         this.sizePlayedArea(this.calculateAreaSize(pendingValue));
      }
      
      protected function sizeLoadedRangeArea(loadedRangeAreaSize:Number) : void
      {
         if(Boolean(this.loadedRangeArea))
         {
            this.loadedRangeArea.setLayoutBoundsSize(Math.round(loadedRangeAreaSize),NaN);
         }
      }
      
      protected function sizePlayedArea(playedAreaSize:Number) : void
      {
         if(Boolean(this.playedArea))
         {
            this.playedArea.setLayoutBoundsSize(Math.round(playedAreaSize),NaN);
         }
      }
      
      private function formatTimeValue(value:Number) : String
      {
         var hours:uint = Math.floor(value / 3600) % 24;
         var minutes:uint = Math.floor(value / 60) % 60;
         var seconds:uint = Math.round(value) % 60;
         var result:String = "";
         if(hours != 0)
         {
            result = hours + ":";
         }
         if(Boolean(result) && minutes < 10)
         {
            result += "0" + minutes + ":";
         }
         else
         {
            result += minutes + ":";
         }
         if(seconds < 10)
         {
            result += "0" + seconds;
         }
         else
         {
            result += seconds;
         }
         return result;
      }
   }
}

