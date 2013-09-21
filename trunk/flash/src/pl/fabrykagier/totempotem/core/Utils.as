package pl.fabrykagier.totempotem.core 
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import mx.skins.halo.ProgressIndeterminateSkin;
	import pl.fabrykagier.totempotem.collisions.BoundingTriangle;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import starling.display.Shape;
	import starling.textures.Texture;
	public class Utils 
	{
		public static function multiplyPointNum(point:Point, number:Number):Point
		{
			return new Point(point.x * number, point.y * number);
		}
		
		public static function addPointPoint(point1:Point, point2:Point):Point
		{
			return new Point(point1.x + point2.x, point1.y + point2.y);
		}
		
		public static function urandom(min:int, max:int):int
		{
			return (Math.floor(Math.random() * (max - min + 1)) + min);
		}
		
		public static function frandom(min:Number, max:Number):Number
		{
			return (Math.random() * (max - min)) + min;
		}
		
		public static function alphabeticalTexture(string1:Texture, string2:Texture):int
		{ 
			if (string1.name < string2.name)
				return -1; 
			else if (string1.name > string2.name) 
				return 1; 
			else
				return 0; 
		};
		
		public static function unalphabeticalTexture(string1:Texture, string2:Texture):int
		{ 
			if (string1.name < string2.name)
				return 1; 
			else if (string1.name > string2.name) 
				return -1; 
			else
				return 0; 
		};
		
		public static function alphabeticalString(string1:String, string2:String):int
		{ 
			if (string1 < string2)
				return -1; 
			else if (string1 > string2) 
				return 1; 
			else
				return 0; 
		};
		
		public static function shapeSort(lhs:ICollidable, rhs:ICollidable):int
		{ 
			var lShape:Shape = lhs.boundingShape;
			var rShape:Shape = rhs.boundingShape;
			if (lShape is BoundingTriangle && rShape is BoundingTriangle)
			{
				if (BoundingTriangle(lShape).flipped && BoundingTriangle(rShape).flipped)
					return 0;
					
				if (BoundingTriangle(lShape).flipped)
					return -1;
					
				return 1;
			}
			else if (lShape is BoundingTriangle) 
				return -1; 
			else if (rShape is BoundingTriangle)
				return 1;
			else
				return 0; 
		};
		
		public static function dot(vec1:Point, vec2:Point):Number
		{
			return vec1.x * vec2.x + vec1.y * vec2.y;
		}

		public static function normalize(vector:Vector3D):Vector3D
		{
			var subX:Number = vector.x * vector.x;
			var subY:Number = vector.y * vector.y;
			var mag:Number = Math.sqrt(subX + subY);
			
			return new Vector3D(vector.x / mag, vector.y / mag);
		}
		
		public static function magPointPoint(point1:Point, point2:Point):Number
		{
			var subX:Number = (point2.x - point1.x) * (point2.x - point1.x);
			var subY:Number = (point2.y - point1.y) * (point2.y - point1.y);
			return Math.sqrt(subX + subY);
		}
		
		public static function closestPointToLine(A:Point, B:Point, P:Point):Point
		{
			var a_to_p:Point = new Point(P.x - A.x, P.y - A.y);
			var a_to_b:Point = new Point(B.x - A.x, B.y - A.y);

			var atb2:Number = Math.pow(a_to_b.x, 2) + Math.pow(a_to_b.y, 2);
			var atp_dot_atb:Number = a_to_p.x * a_to_b.x + a_to_p.y * a_to_b.y;

			var t:Number = atp_dot_atb / atb2;

			return new Point(A.x + a_to_b.x*t, A.y + a_to_b.y * t)
		}
					
		public static function lineIntersectionPoint(ps1:Point, pe1:Point, ps2:Point, pe2:Point):Point
		{
			var A1:Number = pe1.y - ps1.y;
			var B1:Number = ps1.x - pe1.x;
			var C1:Number = A1*ps1.x + B1*ps1.y;
		 
			// Get A,B,C of second line - points : ps2 to pe2
			var A2:Number = pe2.y - ps2.y;
			var B2:Number = ps2.x - pe2.x;
			var C2:Number = A2*ps2.x + B2*ps2.y;
		 
			// Get delta and check if the lines are parallel
			var delta:Number = A1 * B2 - A2 * B1;

			if	(delta == 0.0)
				return new Point(0, 0);
		 
			// now return the Vector2 intersection point
			return new Point((B2*C1 - B1*C2)/delta, (A1*C2 - A2*C1)/delta);
		}
	}
}