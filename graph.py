
import matplotlib.pyplot as plt

size = [1,10,100,1000,2000]

CPU = [0.000003,
0.000007,
0.000005,
0.000016,
0.00005]

GPU1 = [0.000152,
0.010433,
0.010404,
0.010454,
0.010517]

GPU2 = [0.0092,
0.00918,
0.00909,
0.009107,
0.009436]



# plot lines
plt.plot(size, CPU, label = "CPU", color = "blue")
plt.plot(size, GPU1, label = "GPU1", color = "red")
plt.plot(size, GPU2, label = "GPU2", color = "black")
plt.legend()
plt.title("size of array vs time")
#whole number ticks
plt.locator_params(axis="both", integer=True, tight=True)
plt.show()
