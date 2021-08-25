Extension { #name : #Symbol }

{ #category : #'*CoffeeCup-Core' }
Symbol >> asCoffeeCupSelector [

	^ (Character space join:
		   ([ :each | each isAlphaNumeric not ] split: self)) asCamelCase uncapitalized 
		  asValidSelector
]
