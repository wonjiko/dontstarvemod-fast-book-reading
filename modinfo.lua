name = "Fast Book Reading"
description = "Read books faster while keeping the animation and effect in sync. / 책 읽기 애니메이션과 효과를 함께 빠르게 합니다."
author = "wonjiko"
version = "0.1.1"
icon_atlas = "modicon.xml"
icon = "modicon.tex"

api_version = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false

client_only_mod = false
all_clients_require_mod = true

configuration_options = {
    {
        name = "reading_speed",
        label = "Reading speed / 책 읽기 속도",
        hover = "Speed of the reading animation and book effect / 책 읽기 애니메이션과 효과의 속도",
        options = {
            { description = "2x / 2배", data = 2 },
            { description = "3x / 3배", data = 3 },
            { description = "5x / 5배", data = 5 },
        },
        default = 3,
    },
}
