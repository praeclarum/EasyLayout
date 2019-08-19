# EasyLayout


EasyLayout makes writing auto layout code in Xamarin.iOS easier.

This library started out as a gist: [https://gist.github.com/praeclarum/6225853](https://gist.github.com/praeclarum/6225853)


## Constraints from expressions

The basic idea is to write the expression:

```csharp
textbox.Frame.Top == label.Frame.Bottom + 11
```

to mean that we want the *top* of a `textbox` to be offset from the *bottom* of a `label`.

We can create these kinds of constraints using the `UIView` extension method
`AddLayoutConstraints`. It takes a single argument that is a function,
of sorts. This function is never executed, instead it is used to determine the
constraints to apply to the view and its subviews.

Lots of words, let's see an example. Let's layout a simple single field form
using a view controller:

```csharp
class FormExample : UIViewController
{
    UILabel label = new UILabel { Text = "Enter your name, please." };
    UITextField textbox = new UITextField { PlaceholderText = "Your name" };

    public override ViewDidLoad ()
    {
        base.ViewDidLoad ();

        View.AddSubview (label);
        View.AddSubview (textbox);

        View.AddLayoutConstraints (() =>
               label.Frame.Top == View.Frame.Top + 100
            && label.Frame.Left == View.Frame.Left + 50
            && textbox.Frame.Top == label.Frame.Bottom + 10
            && textbox.Frame.Left == label.Frame.Left
            );
    }
}
```

This example shows how to use `&&` to combine multiple constraints (`||` is not supported).

These constraints use the `Frame` property to select which edges of the views
should be constrained. You can also [use anchors][#Constraints_from_anchors].

### Inequalities

You're not confined to `==`, you can also use `<=` and `>=` to create some, um,
interesting UIs.

### Accessing the constraints

Sometimes you want to disable or remove constraints.
To do that, you will want to store them in a variable before adding them to
the view. You can do this using the `ConstrainLayout` function instead of the
`AddLayoutConstraints` function:

```csharp
class RememberExample : UIViewController
{
    UILabel label = new UILabel { Text = "Enter your name, please." };
    UITextField textbox = new UITextField { PlaceholderText = "Your name" };

    NSLayoutConstraint[] constraints = Array.Empty<NSLayoutConstraint> ();

    public override ViewDidLoad ()
    {
        base.ViewDidLoad ();

        View.AddSubview (label);
        View.AddSubview (textbox);

        constraints = View.ConstrainLayout (() =>
               label.Frame.Top == View.Frame.Top + 100
            && label.Frame.Left == View.Frame.Left + 50
            && textbox.Frame.Top == label.Frame.Bottom + 10
            && textbox.Frame.Left == label.Frame.Left
            );

        // Adding constraints has to be done manually now
        View.AddLayoutConstraints (constraints);
    }
}
```



### Constraints from anchors

You can also set anchors equal to each other. This makes using `SafeLayoutGuides` easy.

If you want to make sure that a label is always at the top of a view controller,
then you can set its `TopAnchor` equal to the `SafeLayoutGuides.TopAnchor` of the root view:

```csharp
class AnchorsExample : UIViewController
{
    UILabel label = new UILabel { Text = "Hello, world!" };

    public override ViewDidLoad ()
    {
        base.ViewDidLoad ();

        View.AddSubview (label);
        View.AddLayoutConstraints (() =>
               label.TopAnchor == View.SafeLayoutGuides.TopAnchor
            && label.Frame.CenterX == View.Frame.CenterX
            );
    }
}
```

This will make sure the label is visible no matter what toolbars or safe areas are present.

## Contributing

Yes, please help. This library has been forked so much. I would love to pull back in some cool features. :-)

