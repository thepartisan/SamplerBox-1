from . import globalvars as gv
import time
import os
import subprocess

def mount_samples_dir_rw():
    try:
        if '/samples' in gv.SAMPLES_DIR:
            subprocess.call(['mount', '-vo', 'remount,rw', '/samples'])
            print('/samples has been remounted as READ-WRITE')
        elif '/media' in gv.SAMPLES_DIR:
            subprocess.call(['mount', '-vo', 'remount,rw', '/media'])
            print('/media has been remounted as READ-WRITE')
    except:
        pass

def mount_samples_dir_ro():
    try:
        if gv.SAMPLES_DIR == '/samples':
            subprocess.call(['mount', '-vo', 'remount,ro', '/samples'])
            print('/samples has been remounted as READ-ONLY')
        elif '/media' in gv.SAMPLES_DIR:
            subprocess.call(['mount', '-vo', 'remount,ro', '/media'])
            print('/media has been remounted as READ-ONLY')
    except:
        pass

def mount_boot_rw():
    try:
        if gv.CONFIG_FILE_PATH == "/boot/samplerbox/config.ini": subprocess.call(['mount', '-vo', 'remount,rw', '/boot'])
        print('/boot has been remounted as READ-WRITE')
    except:
        pass

def mount_boot_ro():
    try:
        if gv.CONFIG_FILE_PATH == "/boot/samplerbox/config.ini": subprocess.call(['mount', '-vo', 'remount,ro', '/boot'])
        print('/boot has been remounted as READ-ONLY')
    except:
        pass

def mount_root_rw():
    try:
        subprocess.call(['mount', '-vo', 'remount,rw', '/'])
        print('/ has been remounted as READ-WRITE')
    except:
        pass

def mount_root_ro():
    try:
        subprocess.call(['mount', '-vo', 'remount,ro', '/'])
        print('/ has been remounted as READ-ONLY')
    except:
        pass




class SystemFunctions:
    def __init__(self):
        pass

    def restart(self):

        # Restart the script

        gv.displayer.menu_mode = gv.displayer.DISP_PRESET_MODE

        if gv.USE_HD44780_16x2_LCD:
            gv.displayer.disp_change(str_override='Restarting', line=1, is_priority=True)
            gv.displayer.disp_change(str_override='SamplerBox', line=2, is_priority=True)
        elif gv.USE_HD44780_20x4_LCD:
            gv.displayer.disp_change(str_override=' ', line=1, is_priority=True)
            gv.displayer.disp_change(str_override='Restarting', line=2, is_priority=True)
            gv.displayer.disp_change(str_override='SamplerBox', line=3, is_priority=True)
            gv.displayer.disp_change(str_override=' ', line=4, is_priority=True)

        time.sleep(0.5)

        if gv.IS_DEBIAN:
            gv.displayer.LCD_SYS.lcd.close(clear=False) # does GPIO.cleanup()

        # Python calls 2 command line commands in one line: kill all python scripts, and re-run samplerbox.py
        # subprocess.call('sudo killall python && sudo python ' + str(os.getcwd()) + '/samplerbox.py')
        subprocess.call(['systemctl', 'stop', 'samplerbox'])
        subprocess.call(['killall', 'python'])
        subprocess.call(['python', str(os.getcwd()) + '/samplerbox.py'])

    def reboot(self):

        # Reboot Raspberry Pi

        gv.displayer.menu_mode = gv.displayer.DISP_PRESET_MODE

        if gv.USE_HD44780_16x2_LCD:
            gv.displayer.disp_change(str_override='Rebooting', line=1, is_priority=True)
            gv.displayer.disp_change(str_override='System', line=2, is_priority=True)
        elif gv.USE_HD44780_20x4_LCD:
            gv.displayer.disp_change(str_override=' ', line=1, is_priority=True)
            gv.displayer.disp_change(str_override='Rebooting', line=2, is_priority=True)
            gv.displayer.disp_change(str_override='System', line=3, is_priority=True)
            gv.displayer.disp_change(str_override=' ', line=4, is_priority=True)

        time.sleep(0.5)

        if gv.IS_DEBIAN:
            gv.displayer.LCD_SYS.lcd.close(clear=False) # does GPIO.cleanup()

        subprocess.call('reboot')

    def shutdown(self, log_file=None):

        gv.displayer.menu_mode = gv.displayer.DISP_PRESET_MODE

        if gv.SYSTEM_MODE == 1: gv.nav.text_scroller.stop()  # stop the text scroller in SYS MODE 1
        shutdown_message = 'GOOD BYE!'.center(gv.LCD_COLS, ' ')
        for i in range(gv.LCD_ROWS):
            gv.displayer.disp_change(str_override=shutdown_message, line=(i + 1), timeout=1, is_priority=True)

        time.sleep(0.5)
        gv.sound.close_stream()

        if log_file:
            log_file.close()

        if gv.IS_DEBIAN:
            gv.displayer.LCD_SYS.lcd.close(clear=False) # does GPIO.cleanup()
            print('GPIO was cleaned up')

        exit()
