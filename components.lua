```lua
local Components = {}

Components.Theme = {
    Background = Color3.fromRGB(16, 16, 22),
    Card = Color3.fromRGB(22, 22, 30),
    Input = Color3.fromRGB(27, 27, 36),
    Text = Color3.fromRGB(240, 240, 245),
    SubText = Color3.fromRGB(145, 145, 155),
    Border = Color3.fromRGB(50, 50, 62),
    Accent = Color3.fromRGB(90, 120, 255),
}

function Components.Create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    object.Parent = parent
    return object
end

function Components.Corner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

function Components.Stroke(parent, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = color or Components.Theme.Border
    stroke.Parent = parent
    return stroke
end

function Components.Padding(parent, amount)
    local value = amount or 10

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, value)
    padding.PaddingBottom = UDim.new(0, value)
    padding.PaddingLeft = UDim.new(0, value)
    padding.PaddingRight = UDim.new(0, value)
    padding.Parent = parent

    return padding
end

function Components.Label(parent, text, size, position)
    return Components.Create("TextLabel", {
        Size = size or UDim2.new(1, 0, 0, 30),
        Position = position or UDim2.new(),
        BackgroundTransparency = 1,
        Text = text or "",
        TextColor3 = Components.Theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    }, parent)
end

function Components.Button(parent, text, size, position)
    local button = Components.Create("TextButton", {
        Size = size or UDim2.new(1, 0, 0, 40),
        Position = position or UDim2.new(),
        BackgroundColor3 = Components.Theme.Card,
        BorderSizePixel = 0,
        Text = text or "Button",
        TextColor3 = Components.Theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = true,
    }, parent)

    Components.Corner(button, 8)
    Components.Stroke(button)

    return button
end

function Components.Card(parent, size, position)
    local card = Components.Create("Frame", {
        Size = size or UDim2.new(1, 0, 0, 60),
        Position = position or UDim2.new(),
        BackgroundColor3 = Components.Theme.Card,
        BorderSizePixel = 0,
    }, parent)

    Components.Corner(card, 9)
    Components.Stroke(card)

    return card
end

function Components.Toggle(parent, title, default, callback)
    local enabled = default == true

    local container = Components.Card(
        parent,
        UDim2.new(1, 0, 0, 50)
    )

    Components.Label(
        container,
        title,
        UDim2.new(1, -80, 1, 0),
        UDim2.fromOffset(15, 0)
    )

    local toggle = Components.Create("TextButton", {
        Size = UDim2.fromOffset(55, 26),
        Position = UDim2.new(1, -70, 0.5, -13),
        BackgroundColor3 = enabled
            and Components.Theme.Accent
            or Components.Theme.Input,
        BorderSizePixel = 0,
        Text = enabled and "ON" or "OFF",
        TextColor3 = Components.Theme.Text,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
    }, container)

    Components.Corner(toggle, 8)

    local function Set(value)
        enabled = value == true

        toggle.Text = enabled and "ON" or "OFF"

        toggle.BackgroundColor3 = enabled
            and Components.Theme.Accent
            or Components.Theme.Input
    end

    toggle.MouseButton1Click:Connect(function()
        Set(not enabled)

        if callback then
            callback(enabled)
        end
    end)

    return {
        Container = container,
        Button = toggle,

        Get = function()
            return enabled
        end,

        Set = function(value)
            Set(value)

            if callback then
                callback(enabled)
            end
        end
    }
end

function Components.Checkbox(parent, title, default, callback)
    local enabled = default == true

    local container = Components.Card(
        parent,
        UDim2.new(1, 0, 0, 50)
    )

    Components.Label(
        container,
        title,
        UDim2.new(1, -70, 1, 0),
        UDim2.fromOffset(15, 0)
    )

    local checkbox = Components.Create("TextButton", {
        Size = UDim2.fromOffset(26, 26),
        Position = UDim2.new(1, -40, 0.5, -13),
        BackgroundColor3 = enabled
            and Components.Theme.Accent
            or Components.Theme.Input,
        BorderSizePixel = 0,
        Text = enabled and "✓" or "",
        TextColor3 = Components.Theme.Text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
    }, container)

    Components.Corner(checkbox, 6)
    Components.Stroke(checkbox)

    local function Set(value)
        enabled = value == true

        checkbox.Text = enabled and "✓" or ""

        checkbox.BackgroundColor3 = enabled
            and Components.Theme.Accent
            or Components.Theme.Input
    end

    checkbox.MouseButton1Click:Connect(function()
        Set(not enabled)

        if callback then
            callback(enabled)
        end
    end)

    return {
        Container = container,
        Button = checkbox,

        Get = function()
            return enabled
        end,

        Set = function(value)
            Set(value)

            if callback then
                callback(enabled)
            end
        end
    }
end

function Components.Input(parent, placeholder, default)
    local input = Components.Create("TextBox", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Components.Theme.Input,
        BorderSizePixel = 0,
        PlaceholderText = placeholder or "",
        PlaceholderColor3 = Components.Theme.SubText,
        Text = default or "",
        TextColor3 = Components.Theme.Text,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
    }, parent)

    Components.Corner(input, 8)
    Components.Stroke(input)

    return input
end

function Components.Slider(parent, minimum, maximum, default, callback)
    minimum = minimum or 1
    maximum = maximum or 100
    default = default or minimum

    local value = math.clamp(default, minimum, maximum)

    local container = Components.Card(
        parent,
        UDim2.new(1, 0, 0, 75)
    )

    local valueLabel = Components.Label(
        container,
        tostring(value),
        UDim2.fromOffset(80, 25),
        UDim2.fromOffset(15, 5)
    )

    local bar = Components.Create("Frame", {
        Size = UDim2.new(1, -30, 0, 6),
        Position = UDim2.fromOffset(15, 47),
        BackgroundColor3 = Components.Theme.Input,
        BorderSizePixel = 0,
    }, container)

    Components.Corner(bar, 5)

    local fill = Components.Create("Frame", {
        Size = UDim2.new(
            (value - minimum) / (maximum - minimum),
            0,
            1,
            0
        ),
        BackgroundColor3 = Components.Theme.Accent,
        BorderSizePixel = 0,
    }, bar)

    Components.Corner(fill, 5)

    local dragging = false
    local UserInputService = game:GetService("UserInputService")

    local function Update(inputX)
        local start = bar.AbsolutePosition.X
        local width = bar.AbsoluteSize.X

        if width <= 0 then
            return
        end

        local percent = math.clamp(
            (inputX - start) / width,
            0,
            1
        )

        value = math.floor(
            minimum + (maximum - minimum) * percent + 0.5
        )

        fill.Size = UDim2.new(percent, 0, 1, 0)
        valueLabel.Text = tostring(value)

        if callback then
            callback(value)
        end
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.MouseButton1 then

            dragging = true
            Update(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType ==
            Enum.UserInputType.MouseMovement then

            Update(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.MouseButton1 then

            dragging = false
        end
    end)

    return {
        Container = container,

        Get = function()
            return value
        end,

        Set = function(newValue)
            newValue = tonumber(newValue)

            if not newValue then
                return
            end

            value = math.clamp(
                newValue,
                minimum,
                maximum
            )

            local percent =
                (value - minimum) /
                (maximum - minimum)

            fill.Size =
                UDim2.new(
                    percent,
                    0,
                    1,
                    0
                )

            valueLabel.Text =
                tostring(value)

            if callback then
                callback(value)
            end
        end
    }
end

function Components.Dropdown(parent, title)
    local expanded = false

    local container = Components.Card(
        parent,
        UDim2.new(1, 0, 0, 45)
    )

    local header = Components.Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
    }, container)

    Components.Label(
        container,
        title,
        UDim2.new(1, -50, 0, 45),
        UDim2.fromOffset(15, 0)
    )

    local arrow = Components.Label(
        container,
        "▼",
        UDim2.fromOffset(30, 45),
        UDim2.new(1, -40, 0, 0)
    )

    arrow.TextXAlignment =
        Enum.TextXAlignment.Center

    local content = Instance.new("Frame")

    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 0, 0)
    content.Position = UDim2.fromOffset(10, 45)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = container

    local layout = Instance.new("UIListLayout")

    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content

    local function Update()
        if expanded then
            content.Visible = true

            local height =
                layout.AbsoluteContentSize.Y

            content.Size =
                UDim2.new(
                    1,
                    -20,
                    0,
                    height
                )

            container.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    45 + height + 10
                )

            arrow.Text = "▲"
        else
            content.Visible = false

            content.Size =
                UDim2.new(
                    1,
                    -20,
                    0,
                    0
                )

            container.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    45
                )

            arrow.Text = "▼"
        end
    end

    layout:GetPropertyChangedSignal(
        "AbsoluteContentSize"
    ):Connect(function()
        if expanded then
            Update()
        end
    end)

    header.MouseButton1Click:Connect(function()
        expanded = not expanded
        Update()
    end)

    return {
        Container = content,
        Header = header,
        Button = header,

        IsOpen = function()
            return expanded
        end,

        SetOpen = function(value)
            expanded = value == true
            Update()
        end
    }
end

function Components.Stat(parent, title, value)
    local card = Components.Card(
        parent,
        UDim2.fromOffset(180, 80)
    )

    Components.Label(
        card,
        title,
        UDim2.new(1, -20, 0, 25),
        UDim2.fromOffset(10, 7)
    )

    local valueLabel = Components.Label(
        card,
        tostring(value),
        UDim2.new(1, -20, 0, 35),
        UDim2.fromOffset(10, 35)
    )

    valueLabel.TextSize = 18
    valueLabel.Font = Enum.Font.GothamBold

    return card, valueLabel
end

function Components.DefaultButton(parent, callback)
    local button = Components.Button(
        parent,
        "DEFAULT",
        UDim2.fromOffset(100, 36)
    )

    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return button
end

return Components
```
