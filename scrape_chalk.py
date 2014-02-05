from selenium import selenium
import unittest, time

USER = "USER"
PASS = "PASS"

class NewTest(unittest.TestCase):
    def setUp(self):
        self.verificationErrors = []
        self.selenium = selenium("localhost", 4444, "*firefox C:\\Program Files (x86)\\Mozilla Firefox\\firefox.exe", "https://chalk8.uchicago.edu/")
        self.selenium.start()
    
    def test_selenium(self):
        sel = self.selenium
        sel.open("/webapps/portal/frameset.jsp")
        sel.type("user_id", USER)
        sel.type("password", PASS)
        sel.click("Login")
        sel.wait_for_page_to_load("30000")
        sel.click("link=HIPS 17502 (Spring 11) Sci/Cul/Soc-3: Modern Science")
        sel.wait_for_page_to_load("30000")
        sel.click("link=Response memos")
        sel.wait_for_page_to_load("30000")
        sel.click("link=Response papers")
        sel.wait_for_page_to_load("30000")

        print sel.get_all_links()
        time.sleep(60)

        sel.click("link=Week 1: Experimental Fact")
        sel.wait_for_page_to_load("30000")
        print sel.get_all_links()
        time.sleep(1000)

        sel.wait()
    
    def tearDown(self):
        self.selenium.stop()
        self.assertEqual([], self.verificationErrors)

if __name__ == "__main__":
    unittest.main()
