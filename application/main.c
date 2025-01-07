/**
 * @file main.c
 * @author fy (yfeng880@163.com)
 * @brief  基于gd32f4xx hal库 和 FreeRtos 的简单示例
 * @version 1.0
 * @date 2025-01-07
 *
 * @copyright Copyright (c) 2025
 *
 */
#include <gd32f4xx.h>
#include <FreeRTOS.h>
#include <task.h>

/**
 * @brief 串口初始化
 *
 */
void UART3_init(void)
{
    // Enable the clock for UART3 and GPIOB
    rcu_periph_clock_enable(RCU_UART3);
    rcu_periph_clock_enable(RCU_GPIOC);
    // Configure UART3 TX (PC10) and RX (PC11) pins
    gpio_af_set(GPIOC, GPIO_AF_8, GPIO_PIN_10);
    gpio_af_set(GPIOC, GPIO_AF_8, GPIO_PIN_11);
    gpio_mode_set(GPIOC, GPIO_MODE_AF, GPIO_PUPD_PULLUP, GPIO_PIN_10);
    gpio_output_options_set(GPIOC, GPIO_OTYPE_PP, GPIO_OSPEED_50MHZ, GPIO_PIN_10);
    gpio_mode_set(GPIOC, GPIO_MODE_AF, GPIO_PUPD_PULLUP, GPIO_PIN_11);
    gpio_output_options_set(GPIOC, GPIO_OTYPE_PP, GPIO_OSPEED_50MHZ, GPIO_PIN_11);

    // Configure UART3 parameters
    usart_deinit(UART3);
    usart_baudrate_set(UART3, 115200U);
    usart_word_length_set(UART3, USART_WL_8BIT);
    usart_stop_bit_set(UART3, USART_STB_1BIT);
    usart_parity_config(UART3, USART_PM_NONE);
    usart_hardware_flow_rts_config(UART3, USART_RTS_DISABLE);
    usart_hardware_flow_cts_config(UART3, USART_CTS_DISABLE);
    usart_receive_config(UART3, USART_RECEIVE_ENABLE);
    usart_transmit_config(UART3, USART_TRANSMIT_ENABLE);

    // Enable UART3
    usart_enable(UART3);
}

/**
 * @brief 串口打印函数
 *
 * @param str 待发送的字符串
 */
void UART3_send_string(const char *str)
{
    while (*str)
    {
        usart_data_transmit(UART3, (uint8_t)*str++);
        while (usart_flag_get(UART3, USART_FLAG_TBE) == RESET)
            ;
    }
}
/**
 * @brief 用户自定义的堆栈溢出处理函数
 *
 * @param xTask 发生溢出的任务句柄
 * @param pcTaskName 发生溢出的任务名字
 */
void vApplicationStackOverflowHook(TaskHandle_t xTask, char *pcTaskName)
{
    /* 用户自定义处理：记录溢出任务的名字，或者触发断点 */
    // printf("Stack overflow detected in task: %s\n", pcTaskName);
    UART3_send_string("Stack overflow detected in task!\r\n");
    /* 停止系统运行，或者重启 */
    while (1)
        ;
}

uint32_t systemCoreClock;
/**
 * @brief 串口打印任务
 *
 * @param param
 */
void uart_printf(void *param)
{
    while (1)
    {
        // Toggle the LED
        gpio_bit_write(GPIOC, GPIO_PIN_13, (bit_status)(1 - gpio_input_bit_get(GPIOC, GPIO_PIN_13)));
        // Send a string via UART3
        UART3_send_string("Hello, UART3!\r\n");
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}

int main(void)
{
    UART3_init();
    SystemCoreClockUpdate();
    systemCoreClock = SystemCoreClock;

    // Enable the clock for GPIO port
    rcu_periph_clock_enable(RCU_GPIOC);

    // Configure the LED pin as output
    gpio_mode_set(GPIOC, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO_PIN_13);
    gpio_output_options_set(GPIOC, GPIO_OTYPE_PP, GPIO_OSPEED_50MHZ, GPIO_PIN_13);

    TaskHandle_t task_uart;
    xTaskCreate(uart_printf,
                "uart_printf",
                128,
                NULL,
                3,
                &task_uart);
    vTaskStartScheduler();
}

void HardFault_Handler(void)
{
    while (1)
        ;
}
void delay(void)
{
    for (volatile uint32_t i = 0; i < 10000000; i++)
        ;
}