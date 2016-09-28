package metric

import (
    "metrics"
)

func main() {
    meter := metrics.NewMeter("system/memory/allocs")
    timer := metrics.NewTimer("chain/inserts")
}
