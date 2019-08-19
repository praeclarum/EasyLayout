# EasyLayout

[![Build Status](https://app.bitrise.io/app/bf937f36c4e5d005/status.svg?token=67ly35ZNSbT-FEk6jMQqog&branch=master)](https://app.bitrise.io/app/bf937f36c4e5d005)

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
should be constrained. You can also [use anchors](#constraints-from-anchors).

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

## Realistic example

Here's a bit of code from a custom `UITableViewCell` I created.
When the cell is created, it creates a lot of constraints for its subviews.

Note the use of baselines and centering. Also note the use of offsets
that can be variables. The use of inequalities allows the layout engine
some flexibility in positioning when cells get small.

```csharp
ContentView.ConstrainLayout (() =>

	border.Frame.Top == ContentView.Frame.Top &&
	border.Frame.Height == 0.5f &&
	border.Frame.Left == ContentView.Frame.Left &&
	border.Frame.Right == ContentView.Frame.Right &&

	nameLabel.Frame.Left == ContentView.Frame.Left + hpad &&
	nameLabel.Frame.Right == ContentView.Frame.GetMidX () - 5.5f &&
	nameLabel.Frame.Top >= ContentView.Frame.Top + vpad &&
	nameLabel.Frame.Bottom <= ContentView.Frame.Bottom - vpad &&
	nameLabel.Frame.GetMidY () == ContentView.Frame.GetMidY () &&

	gestureView.Frame.Left <= ContentView.Frame.GetMidX () - 22 &&
	gestureView.Frame.Right >= scalarLabel.Frame.Right + 22 &&
	gestureView.Frame.Width >= 88 &&
	gestureView.Frame.Top == ContentView.Frame.Top &&
	gestureView.Frame.Bottom == ContentView.Frame.Bottom &&

	scalarLabel.Frame.Bottom == ContentView.Frame.Bottom - vpad &&
	scalarLabel.Frame.Left == nameLabel.Frame.Right + 11 &&
	scalarLabel.Frame.Right <= ContentView.Frame.Right - hpad &&
	scalarLabel.Frame.GetMidY () == ContentView.Frame.GetMidY () &&

	unitsLabel.Frame.Left == scalarLabel.Frame.Right + 1 &&
	unitsLabel.Frame.GetBaseline () == scalarLabel.Frame.GetBaseline ()

);
```

## Contributing

Yes, please help. This library has been forked so much. I would love to pull back in some cool features. :-)

